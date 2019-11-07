
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
80100015:	b8 00 b0 10 00       	mov    $0x10b000,%eax
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
80100028:	bc e0 d5 10 80       	mov    $0x8010d5e0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 a0 2e 10 80       	mov    $0x80102ea0,%eax
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
80100044:	bb 14 d6 10 80       	mov    $0x8010d614,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 00 83 10 80       	push   $0x80108300
80100051:	68 e0 d5 10 80       	push   $0x8010d5e0
80100056:	e8 75 54 00 00       	call   801054d0 <initlock>
  bcache.head.prev = &bcache.head;
8010005b:	c7 05 2c 1d 11 80 dc 	movl   $0x80111cdc,0x80111d2c
80100062:	1c 11 80 
  bcache.head.next = &bcache.head;
80100065:	c7 05 30 1d 11 80 dc 	movl   $0x80111cdc,0x80111d30
8010006c:	1c 11 80 
8010006f:	83 c4 10             	add    $0x10,%esp
80100072:	ba dc 1c 11 80       	mov    $0x80111cdc,%edx
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 c3                	mov    %eax,%ebx
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100082:	8d 43 0c             	lea    0xc(%ebx),%eax
80100085:	83 ec 08             	sub    $0x8,%esp
    b->next = bcache.head.next;
80100088:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008b:	c7 43 50 dc 1c 11 80 	movl   $0x80111cdc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 07 83 10 80       	push   $0x80108307
80100097:	50                   	push   %eax
80100098:	e8 03 53 00 00       	call   801053a0 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 30 1d 11 80       	mov    0x80111d30,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	83 c4 10             	add    $0x10,%esp
801000a5:	89 da                	mov    %ebx,%edx
    bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
    bcache.head.next = b;
801000b0:	89 1d 30 1d 11 80    	mov    %ebx,0x80111d30
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d dc 1c 11 80       	cmp    $0x80111cdc,%eax
801000bb:	72 c3                	jb     80100080 <binit+0x40>
  }
}
801000bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c0:	c9                   	leave  
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

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
801000df:	68 e0 d5 10 80       	push   $0x8010d5e0
801000e4:	e8 27 55 00 00       	call   80105610 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 30 1d 11 80    	mov    0x80111d30,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb dc 1c 11 80    	cmp    $0x80111cdc,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb dc 1c 11 80    	cmp    $0x80111cdc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	90                   	nop
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 2c 1d 11 80    	mov    0x80111d2c,%ebx
80100126:	81 fb dc 1c 11 80    	cmp    $0x80111cdc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 60                	jmp    80100190 <bread+0xc0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb dc 1c 11 80    	cmp    $0x80111cdc,%ebx
80100139:	74 55                	je     80100190 <bread+0xc0>
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
8010015d:	68 e0 d5 10 80       	push   $0x8010d5e0
80100162:	e8 69 55 00 00       	call   801056d0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 6e 52 00 00       	call   801053e0 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
    iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 9d 1f 00 00       	call   80102120 <iderw>
80100183:	83 c4 10             	add    $0x10,%esp
  }
  return b;
}
80100186:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100189:	89 d8                	mov    %ebx,%eax
8010018b:	5b                   	pop    %ebx
8010018c:	5e                   	pop    %esi
8010018d:	5f                   	pop    %edi
8010018e:	5d                   	pop    %ebp
8010018f:	c3                   	ret    
  panic("bget: no buffers");
80100190:	83 ec 0c             	sub    $0xc,%esp
80100193:	68 0e 83 10 80       	push   $0x8010830e
80100198:	e8 f3 01 00 00       	call   80100390 <panic>
8010019d:	8d 76 00             	lea    0x0(%esi),%esi

801001a0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	53                   	push   %ebx
801001a4:	83 ec 10             	sub    $0x10,%esp
801001a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801001ad:	50                   	push   %eax
801001ae:	e8 cd 52 00 00       	call   80105480 <holdingsleep>
801001b3:	83 c4 10             	add    $0x10,%esp
801001b6:	85 c0                	test   %eax,%eax
801001b8:	74 0f                	je     801001c9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ba:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001bd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001c3:	c9                   	leave  
  iderw(b);
801001c4:	e9 57 1f 00 00       	jmp    80102120 <iderw>
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 1f 83 10 80       	push   $0x8010831f
801001d1:	e8 ba 01 00 00       	call   80100390 <panic>
801001d6:	8d 76 00             	lea    0x0(%esi),%esi
801001d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801001e0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001e0:	55                   	push   %ebp
801001e1:	89 e5                	mov    %esp,%ebp
801001e3:	56                   	push   %esi
801001e4:	53                   	push   %ebx
801001e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001e8:	83 ec 0c             	sub    $0xc,%esp
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	56                   	push   %esi
801001ef:	e8 8c 52 00 00       	call   80105480 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 3c 52 00 00       	call   80105440 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 e0 d5 10 80 	movl   $0x8010d5e0,(%esp)
8010020b:	e8 00 54 00 00       	call   80105610 <acquire>
  b->refcnt--;
80100210:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100213:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100216:	83 e8 01             	sub    $0x1,%eax
  if (b->refcnt == 0) {
80100219:	85 c0                	test   %eax,%eax
  b->refcnt--;
8010021b:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010021e:	75 2f                	jne    8010024f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100220:	8b 43 54             	mov    0x54(%ebx),%eax
80100223:	8b 53 50             	mov    0x50(%ebx),%edx
80100226:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100229:	8b 43 50             	mov    0x50(%ebx),%eax
8010022c:	8b 53 54             	mov    0x54(%ebx),%edx
8010022f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100232:	a1 30 1d 11 80       	mov    0x80111d30,%eax
    b->prev = &bcache.head;
80100237:	c7 43 50 dc 1c 11 80 	movl   $0x80111cdc,0x50(%ebx)
    b->next = bcache.head.next;
8010023e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100241:	a1 30 1d 11 80       	mov    0x80111d30,%eax
80100246:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100249:	89 1d 30 1d 11 80    	mov    %ebx,0x80111d30
  }
  
  release(&bcache.lock);
8010024f:	c7 45 08 e0 d5 10 80 	movl   $0x8010d5e0,0x8(%ebp)
}
80100256:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100259:	5b                   	pop    %ebx
8010025a:	5e                   	pop    %esi
8010025b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010025c:	e9 6f 54 00 00       	jmp    801056d0 <release>
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 26 83 10 80       	push   $0x80108326
80100269:	e8 22 01 00 00       	call   80100390 <panic>
8010026e:	66 90                	xchg   %ax,%ax

80100270 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100270:	55                   	push   %ebp
80100271:	89 e5                	mov    %esp,%ebp
80100273:	57                   	push   %edi
80100274:	56                   	push   %esi
80100275:	53                   	push   %ebx
80100276:	83 ec 28             	sub    $0x28,%esp
80100279:	8b 7d 08             	mov    0x8(%ebp),%edi
8010027c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010027f:	57                   	push   %edi
80100280:	e8 db 14 00 00       	call   80101760 <iunlock>
  target = n;
  acquire(&cons.lock);
80100285:	c7 04 24 40 c5 10 80 	movl   $0x8010c540,(%esp)
8010028c:	e8 7f 53 00 00       	call   80105610 <acquire>
  while(n > 0){
80100291:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100294:	83 c4 10             	add    $0x10,%esp
80100297:	31 c0                	xor    %eax,%eax
80100299:	85 db                	test   %ebx,%ebx
8010029b:	0f 8e a1 00 00 00    	jle    80100342 <consoleread+0xd2>
    while(input.r == input.w){
801002a1:	8b 15 c0 1f 11 80    	mov    0x80111fc0,%edx
801002a7:	39 15 c4 1f 11 80    	cmp    %edx,0x80111fc4
801002ad:	74 2c                	je     801002db <consoleread+0x6b>
801002af:	eb 5f                	jmp    80100310 <consoleread+0xa0>
801002b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b8:	83 ec 08             	sub    $0x8,%esp
801002bb:	68 40 c5 10 80       	push   $0x8010c540
801002c0:	68 c0 1f 11 80       	push   $0x80111fc0
801002c5:	e8 c6 49 00 00       	call   80104c90 <sleep>
    while(input.r == input.w){
801002ca:	8b 15 c0 1f 11 80    	mov    0x80111fc0,%edx
801002d0:	83 c4 10             	add    $0x10,%esp
801002d3:	3b 15 c4 1f 11 80    	cmp    0x80111fc4,%edx
801002d9:	75 35                	jne    80100310 <consoleread+0xa0>
      if(myproc()->killed){
801002db:	e8 c0 35 00 00       	call   801038a0 <myproc>
801002e0:	8b 40 24             	mov    0x24(%eax),%eax
801002e3:	85 c0                	test   %eax,%eax
801002e5:	74 d1                	je     801002b8 <consoleread+0x48>
        release(&cons.lock);
801002e7:	83 ec 0c             	sub    $0xc,%esp
801002ea:	68 40 c5 10 80       	push   $0x8010c540
801002ef:	e8 dc 53 00 00       	call   801056d0 <release>
        ilock(ip);
801002f4:	89 3c 24             	mov    %edi,(%esp)
801002f7:	e8 84 13 00 00       	call   80101680 <ilock>
        return -1;
801002fc:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
801002ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80100302:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100307:	5b                   	pop    %ebx
80100308:	5e                   	pop    %esi
80100309:	5f                   	pop    %edi
8010030a:	5d                   	pop    %ebp
8010030b:	c3                   	ret    
8010030c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100310:	8d 42 01             	lea    0x1(%edx),%eax
80100313:	a3 c0 1f 11 80       	mov    %eax,0x80111fc0
80100318:	89 d0                	mov    %edx,%eax
8010031a:	83 e0 7f             	and    $0x7f,%eax
8010031d:	0f be 80 40 1f 11 80 	movsbl -0x7feee0c0(%eax),%eax
    if(c == C('D')){  // EOF
80100324:	83 f8 04             	cmp    $0x4,%eax
80100327:	74 3f                	je     80100368 <consoleread+0xf8>
    *dst++ = c;
80100329:	83 c6 01             	add    $0x1,%esi
    --n;
8010032c:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
8010032f:	83 f8 0a             	cmp    $0xa,%eax
    *dst++ = c;
80100332:	88 46 ff             	mov    %al,-0x1(%esi)
    if(c == '\n')
80100335:	74 43                	je     8010037a <consoleread+0x10a>
  while(n > 0){
80100337:	85 db                	test   %ebx,%ebx
80100339:	0f 85 62 ff ff ff    	jne    801002a1 <consoleread+0x31>
8010033f:	8b 45 10             	mov    0x10(%ebp),%eax
  release(&cons.lock);
80100342:	83 ec 0c             	sub    $0xc,%esp
80100345:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100348:	68 40 c5 10 80       	push   $0x8010c540
8010034d:	e8 7e 53 00 00       	call   801056d0 <release>
  ilock(ip);
80100352:	89 3c 24             	mov    %edi,(%esp)
80100355:	e8 26 13 00 00       	call   80101680 <ilock>
  return target - n;
8010035a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010035d:	83 c4 10             	add    $0x10,%esp
}
80100360:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100363:	5b                   	pop    %ebx
80100364:	5e                   	pop    %esi
80100365:	5f                   	pop    %edi
80100366:	5d                   	pop    %ebp
80100367:	c3                   	ret    
80100368:	8b 45 10             	mov    0x10(%ebp),%eax
8010036b:	29 d8                	sub    %ebx,%eax
      if(n < target){
8010036d:	3b 5d 10             	cmp    0x10(%ebp),%ebx
80100370:	73 d0                	jae    80100342 <consoleread+0xd2>
        input.r--;
80100372:	89 15 c0 1f 11 80    	mov    %edx,0x80111fc0
80100378:	eb c8                	jmp    80100342 <consoleread+0xd2>
8010037a:	8b 45 10             	mov    0x10(%ebp),%eax
8010037d:	29 d8                	sub    %ebx,%eax
8010037f:	eb c1                	jmp    80100342 <consoleread+0xd2>
80100381:	eb 0d                	jmp    80100390 <panic>
80100383:	90                   	nop
80100384:	90                   	nop
80100385:	90                   	nop
80100386:	90                   	nop
80100387:	90                   	nop
80100388:	90                   	nop
80100389:	90                   	nop
8010038a:	90                   	nop
8010038b:	90                   	nop
8010038c:	90                   	nop
8010038d:	90                   	nop
8010038e:	90                   	nop
8010038f:	90                   	nop

80100390 <panic>:
{
80100390:	55                   	push   %ebp
80100391:	89 e5                	mov    %esp,%ebp
80100393:	56                   	push   %esi
80100394:	53                   	push   %ebx
80100395:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100398:	fa                   	cli    
  cons.locking = 0;
80100399:	c7 05 74 c5 10 80 00 	movl   $0x0,0x8010c574
801003a0:	00 00 00 
  getcallerpcs(&s, pcs);
801003a3:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003a6:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003a9:	e8 82 23 00 00       	call   80102730 <lapicid>
801003ae:	83 ec 08             	sub    $0x8,%esp
801003b1:	50                   	push   %eax
801003b2:	68 2d 83 10 80       	push   $0x8010832d
801003b7:	e8 a4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
801003bc:	58                   	pop    %eax
801003bd:	ff 75 08             	pushl  0x8(%ebp)
801003c0:	e8 9b 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003c5:	c7 04 24 37 90 10 80 	movl   $0x80109037,(%esp)
801003cc:	e8 8f 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003d1:	5a                   	pop    %edx
801003d2:	8d 45 08             	lea    0x8(%ebp),%eax
801003d5:	59                   	pop    %ecx
801003d6:	53                   	push   %ebx
801003d7:	50                   	push   %eax
801003d8:	e8 13 51 00 00       	call   801054f0 <getcallerpcs>
801003dd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e0:	83 ec 08             	sub    $0x8,%esp
801003e3:	ff 33                	pushl  (%ebx)
801003e5:	83 c3 04             	add    $0x4,%ebx
801003e8:	68 41 83 10 80       	push   $0x80108341
801003ed:	e8 6e 02 00 00       	call   80100660 <cprintf>
  for(i=0; i<10; i++)
801003f2:	83 c4 10             	add    $0x10,%esp
801003f5:	39 f3                	cmp    %esi,%ebx
801003f7:	75 e7                	jne    801003e0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003f9:	c7 05 78 c5 10 80 01 	movl   $0x1,0x8010c578
80100400:	00 00 00 
80100403:	eb fe                	jmp    80100403 <panic+0x73>
80100405:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100410 <consputc>:
  if(panicked){
80100410:	8b 0d 78 c5 10 80    	mov    0x8010c578,%ecx
80100416:	85 c9                	test   %ecx,%ecx
80100418:	74 06                	je     80100420 <consputc+0x10>
8010041a:	fa                   	cli    
8010041b:	eb fe                	jmp    8010041b <consputc+0xb>
8010041d:	8d 76 00             	lea    0x0(%esi),%esi
{
80100420:	55                   	push   %ebp
80100421:	89 e5                	mov    %esp,%ebp
80100423:	57                   	push   %edi
80100424:	56                   	push   %esi
80100425:	53                   	push   %ebx
80100426:	89 c6                	mov    %eax,%esi
80100428:	83 ec 0c             	sub    $0xc,%esp
  if(c == BACKSPACE){
8010042b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100430:	0f 84 b1 00 00 00    	je     801004e7 <consputc+0xd7>
    uartputc(c);
80100436:	83 ec 0c             	sub    $0xc,%esp
80100439:	50                   	push   %eax
8010043a:	e8 d1 6a 00 00       	call   80106f10 <uartputc>
8010043f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100442:	bb d4 03 00 00       	mov    $0x3d4,%ebx
80100447:	b8 0e 00 00 00       	mov    $0xe,%eax
8010044c:	89 da                	mov    %ebx,%edx
8010044e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010044f:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100454:	89 ca                	mov    %ecx,%edx
80100456:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100457:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010045a:	89 da                	mov    %ebx,%edx
8010045c:	c1 e0 08             	shl    $0x8,%eax
8010045f:	89 c7                	mov    %eax,%edi
80100461:	b8 0f 00 00 00       	mov    $0xf,%eax
80100466:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100467:	89 ca                	mov    %ecx,%edx
80100469:	ec                   	in     (%dx),%al
8010046a:	0f b6 d8             	movzbl %al,%ebx
  pos |= inb(CRTPORT+1);
8010046d:	09 fb                	or     %edi,%ebx
  if(c == '\n')
8010046f:	83 fe 0a             	cmp    $0xa,%esi
80100472:	0f 84 f3 00 00 00    	je     8010056b <consputc+0x15b>
  else if(c == BACKSPACE){
80100478:	81 fe 00 01 00 00    	cmp    $0x100,%esi
8010047e:	0f 84 d7 00 00 00    	je     8010055b <consputc+0x14b>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100484:	89 f0                	mov    %esi,%eax
80100486:	0f b6 c0             	movzbl %al,%eax
80100489:	80 cc 07             	or     $0x7,%ah
8010048c:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
80100493:	80 
80100494:	83 c3 01             	add    $0x1,%ebx
  if(pos < 0 || pos > 25*80)
80100497:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
8010049d:	0f 8f ab 00 00 00    	jg     8010054e <consputc+0x13e>
  if((pos/80) >= 24){  // Scroll up.
801004a3:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
801004a9:	7f 66                	jg     80100511 <consputc+0x101>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004ab:	be d4 03 00 00       	mov    $0x3d4,%esi
801004b0:	b8 0e 00 00 00       	mov    $0xe,%eax
801004b5:	89 f2                	mov    %esi,%edx
801004b7:	ee                   	out    %al,(%dx)
801004b8:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
  outb(CRTPORT+1, pos>>8);
801004bd:	89 d8                	mov    %ebx,%eax
801004bf:	c1 f8 08             	sar    $0x8,%eax
801004c2:	89 ca                	mov    %ecx,%edx
801004c4:	ee                   	out    %al,(%dx)
801004c5:	b8 0f 00 00 00       	mov    $0xf,%eax
801004ca:	89 f2                	mov    %esi,%edx
801004cc:	ee                   	out    %al,(%dx)
801004cd:	89 d8                	mov    %ebx,%eax
801004cf:	89 ca                	mov    %ecx,%edx
801004d1:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004d2:	b8 20 07 00 00       	mov    $0x720,%eax
801004d7:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
801004de:	80 
}
801004df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004e2:	5b                   	pop    %ebx
801004e3:	5e                   	pop    %esi
801004e4:	5f                   	pop    %edi
801004e5:	5d                   	pop    %ebp
801004e6:	c3                   	ret    
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004e7:	83 ec 0c             	sub    $0xc,%esp
801004ea:	6a 08                	push   $0x8
801004ec:	e8 1f 6a 00 00       	call   80106f10 <uartputc>
801004f1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f8:	e8 13 6a 00 00       	call   80106f10 <uartputc>
801004fd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100504:	e8 07 6a 00 00       	call   80106f10 <uartputc>
80100509:	83 c4 10             	add    $0x10,%esp
8010050c:	e9 31 ff ff ff       	jmp    80100442 <consputc+0x32>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100511:	52                   	push   %edx
80100512:	68 60 0e 00 00       	push   $0xe60
    pos -= 80;
80100517:	83 eb 50             	sub    $0x50,%ebx
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
8010051a:	68 a0 80 0b 80       	push   $0x800b80a0
8010051f:	68 00 80 0b 80       	push   $0x800b8000
80100524:	e8 a7 52 00 00       	call   801057d0 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100529:	b8 80 07 00 00       	mov    $0x780,%eax
8010052e:	83 c4 0c             	add    $0xc,%esp
80100531:	29 d8                	sub    %ebx,%eax
80100533:	01 c0                	add    %eax,%eax
80100535:	50                   	push   %eax
80100536:	8d 04 1b             	lea    (%ebx,%ebx,1),%eax
80100539:	6a 00                	push   $0x0
8010053b:	2d 00 80 f4 7f       	sub    $0x7ff48000,%eax
80100540:	50                   	push   %eax
80100541:	e8 da 51 00 00       	call   80105720 <memset>
80100546:	83 c4 10             	add    $0x10,%esp
80100549:	e9 5d ff ff ff       	jmp    801004ab <consputc+0x9b>
    panic("pos under/overflow");
8010054e:	83 ec 0c             	sub    $0xc,%esp
80100551:	68 45 83 10 80       	push   $0x80108345
80100556:	e8 35 fe ff ff       	call   80100390 <panic>
    if(pos > 0) --pos;
8010055b:	85 db                	test   %ebx,%ebx
8010055d:	0f 84 48 ff ff ff    	je     801004ab <consputc+0x9b>
80100563:	83 eb 01             	sub    $0x1,%ebx
80100566:	e9 2c ff ff ff       	jmp    80100497 <consputc+0x87>
    pos += 80 - pos%80;
8010056b:	89 d8                	mov    %ebx,%eax
8010056d:	b9 50 00 00 00       	mov    $0x50,%ecx
80100572:	99                   	cltd   
80100573:	f7 f9                	idiv   %ecx
80100575:	29 d1                	sub    %edx,%ecx
80100577:	01 cb                	add    %ecx,%ebx
80100579:	e9 19 ff ff ff       	jmp    80100497 <consputc+0x87>
8010057e:	66 90                	xchg   %ax,%ax

80100580 <printint>:
{
80100580:	55                   	push   %ebp
80100581:	89 e5                	mov    %esp,%ebp
80100583:	57                   	push   %edi
80100584:	56                   	push   %esi
80100585:	53                   	push   %ebx
80100586:	89 d3                	mov    %edx,%ebx
80100588:	83 ec 2c             	sub    $0x2c,%esp
  if(sign && (sign = xx < 0))
8010058b:	85 c9                	test   %ecx,%ecx
{
8010058d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
80100590:	74 04                	je     80100596 <printint+0x16>
80100592:	85 c0                	test   %eax,%eax
80100594:	78 5a                	js     801005f0 <printint+0x70>
    x = xx;
80100596:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  i = 0;
8010059d:	31 c9                	xor    %ecx,%ecx
8010059f:	8d 75 d7             	lea    -0x29(%ebp),%esi
801005a2:	eb 06                	jmp    801005aa <printint+0x2a>
801005a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    buf[i++] = digits[x % base];
801005a8:	89 f9                	mov    %edi,%ecx
801005aa:	31 d2                	xor    %edx,%edx
801005ac:	8d 79 01             	lea    0x1(%ecx),%edi
801005af:	f7 f3                	div    %ebx
801005b1:	0f b6 92 70 83 10 80 	movzbl -0x7fef7c90(%edx),%edx
  }while((x /= base) != 0);
801005b8:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
801005ba:	88 14 3e             	mov    %dl,(%esi,%edi,1)
  }while((x /= base) != 0);
801005bd:	75 e9                	jne    801005a8 <printint+0x28>
  if(sign)
801005bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801005c2:	85 c0                	test   %eax,%eax
801005c4:	74 08                	je     801005ce <printint+0x4e>
    buf[i++] = '-';
801005c6:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
801005cb:	8d 79 02             	lea    0x2(%ecx),%edi
801005ce:	8d 5c 3d d7          	lea    -0x29(%ebp,%edi,1),%ebx
801005d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    consputc(buf[i]);
801005d8:	0f be 03             	movsbl (%ebx),%eax
801005db:	83 eb 01             	sub    $0x1,%ebx
801005de:	e8 2d fe ff ff       	call   80100410 <consputc>
  while(--i >= 0)
801005e3:	39 f3                	cmp    %esi,%ebx
801005e5:	75 f1                	jne    801005d8 <printint+0x58>
}
801005e7:	83 c4 2c             	add    $0x2c,%esp
801005ea:	5b                   	pop    %ebx
801005eb:	5e                   	pop    %esi
801005ec:	5f                   	pop    %edi
801005ed:	5d                   	pop    %ebp
801005ee:	c3                   	ret    
801005ef:	90                   	nop
    x = -xx;
801005f0:	f7 d8                	neg    %eax
801005f2:	eb a9                	jmp    8010059d <printint+0x1d>
801005f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80100600 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	83 ec 18             	sub    $0x18,%esp
80100609:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
8010060c:	ff 75 08             	pushl  0x8(%ebp)
8010060f:	e8 4c 11 00 00       	call   80101760 <iunlock>
  acquire(&cons.lock);
80100614:	c7 04 24 40 c5 10 80 	movl   $0x8010c540,(%esp)
8010061b:	e8 f0 4f 00 00       	call   80105610 <acquire>
  for(i = 0; i < n; i++)
80100620:	83 c4 10             	add    $0x10,%esp
80100623:	85 f6                	test   %esi,%esi
80100625:	7e 18                	jle    8010063f <consolewrite+0x3f>
80100627:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010062a:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010062d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100630:	0f b6 07             	movzbl (%edi),%eax
80100633:	83 c7 01             	add    $0x1,%edi
80100636:	e8 d5 fd ff ff       	call   80100410 <consputc>
  for(i = 0; i < n; i++)
8010063b:	39 fb                	cmp    %edi,%ebx
8010063d:	75 f1                	jne    80100630 <consolewrite+0x30>
  release(&cons.lock);
8010063f:	83 ec 0c             	sub    $0xc,%esp
80100642:	68 40 c5 10 80       	push   $0x8010c540
80100647:	e8 84 50 00 00       	call   801056d0 <release>
  ilock(ip);
8010064c:	58                   	pop    %eax
8010064d:	ff 75 08             	pushl  0x8(%ebp)
80100650:	e8 2b 10 00 00       	call   80101680 <ilock>

  return n;
}
80100655:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100658:	89 f0                	mov    %esi,%eax
8010065a:	5b                   	pop    %ebx
8010065b:	5e                   	pop    %esi
8010065c:	5f                   	pop    %edi
8010065d:	5d                   	pop    %ebp
8010065e:	c3                   	ret    
8010065f:	90                   	nop

80100660 <cprintf>:
{
80100660:	55                   	push   %ebp
80100661:	89 e5                	mov    %esp,%ebp
80100663:	57                   	push   %edi
80100664:	56                   	push   %esi
80100665:	53                   	push   %ebx
80100666:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
80100669:	a1 74 c5 10 80       	mov    0x8010c574,%eax
  if(locking)
8010066e:	85 c0                	test   %eax,%eax
  locking = cons.locking;
80100670:	89 45 dc             	mov    %eax,-0x24(%ebp)
  if(locking)
80100673:	0f 85 6f 01 00 00    	jne    801007e8 <cprintf+0x188>
  if (fmt == 0)
80100679:	8b 45 08             	mov    0x8(%ebp),%eax
8010067c:	85 c0                	test   %eax,%eax
8010067e:	89 c7                	mov    %eax,%edi
80100680:	0f 84 77 01 00 00    	je     801007fd <cprintf+0x19d>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100686:	0f b6 00             	movzbl (%eax),%eax
  argp = (uint*)(void*)(&fmt + 1);
80100689:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010068c:	31 db                	xor    %ebx,%ebx
  argp = (uint*)(void*)(&fmt + 1);
8010068e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100691:	85 c0                	test   %eax,%eax
80100693:	75 56                	jne    801006eb <cprintf+0x8b>
80100695:	eb 79                	jmp    80100710 <cprintf+0xb0>
80100697:	89 f6                	mov    %esi,%esi
80100699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    c = fmt[++i] & 0xff;
801006a0:	0f b6 16             	movzbl (%esi),%edx
    if(c == 0)
801006a3:	85 d2                	test   %edx,%edx
801006a5:	74 69                	je     80100710 <cprintf+0xb0>
801006a7:	83 c3 02             	add    $0x2,%ebx
    switch(c){
801006aa:	83 fa 70             	cmp    $0x70,%edx
801006ad:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
801006b0:	0f 84 84 00 00 00    	je     8010073a <cprintf+0xda>
801006b6:	7f 78                	jg     80100730 <cprintf+0xd0>
801006b8:	83 fa 25             	cmp    $0x25,%edx
801006bb:	0f 84 ff 00 00 00    	je     801007c0 <cprintf+0x160>
801006c1:	83 fa 64             	cmp    $0x64,%edx
801006c4:	0f 85 8e 00 00 00    	jne    80100758 <cprintf+0xf8>
      printint(*argp++, 10, 1);
801006ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801006cd:	ba 0a 00 00 00       	mov    $0xa,%edx
801006d2:	8d 48 04             	lea    0x4(%eax),%ecx
801006d5:	8b 00                	mov    (%eax),%eax
801006d7:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801006da:	b9 01 00 00 00       	mov    $0x1,%ecx
801006df:	e8 9c fe ff ff       	call   80100580 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006e4:	0f b6 06             	movzbl (%esi),%eax
801006e7:	85 c0                	test   %eax,%eax
801006e9:	74 25                	je     80100710 <cprintf+0xb0>
801006eb:	8d 53 01             	lea    0x1(%ebx),%edx
    if(c != '%'){
801006ee:	83 f8 25             	cmp    $0x25,%eax
801006f1:	8d 34 17             	lea    (%edi,%edx,1),%esi
801006f4:	74 aa                	je     801006a0 <cprintf+0x40>
801006f6:	89 55 e0             	mov    %edx,-0x20(%ebp)
      consputc(c);
801006f9:	e8 12 fd ff ff       	call   80100410 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006fe:	0f b6 06             	movzbl (%esi),%eax
      continue;
80100701:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100704:	89 d3                	mov    %edx,%ebx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100706:	85 c0                	test   %eax,%eax
80100708:	75 e1                	jne    801006eb <cprintf+0x8b>
8010070a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(locking)
80100710:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100713:	85 c0                	test   %eax,%eax
80100715:	74 10                	je     80100727 <cprintf+0xc7>
    release(&cons.lock);
80100717:	83 ec 0c             	sub    $0xc,%esp
8010071a:	68 40 c5 10 80       	push   $0x8010c540
8010071f:	e8 ac 4f 00 00       	call   801056d0 <release>
80100724:	83 c4 10             	add    $0x10,%esp
}
80100727:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010072a:	5b                   	pop    %ebx
8010072b:	5e                   	pop    %esi
8010072c:	5f                   	pop    %edi
8010072d:	5d                   	pop    %ebp
8010072e:	c3                   	ret    
8010072f:	90                   	nop
    switch(c){
80100730:	83 fa 73             	cmp    $0x73,%edx
80100733:	74 43                	je     80100778 <cprintf+0x118>
80100735:	83 fa 78             	cmp    $0x78,%edx
80100738:	75 1e                	jne    80100758 <cprintf+0xf8>
      printint(*argp++, 16, 0);
8010073a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010073d:	ba 10 00 00 00       	mov    $0x10,%edx
80100742:	8d 48 04             	lea    0x4(%eax),%ecx
80100745:	8b 00                	mov    (%eax),%eax
80100747:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010074a:	31 c9                	xor    %ecx,%ecx
8010074c:	e8 2f fe ff ff       	call   80100580 <printint>
      break;
80100751:	eb 91                	jmp    801006e4 <cprintf+0x84>
80100753:	90                   	nop
80100754:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      consputc('%');
80100758:	b8 25 00 00 00       	mov    $0x25,%eax
8010075d:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100760:	e8 ab fc ff ff       	call   80100410 <consputc>
      consputc(c);
80100765:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100768:	89 d0                	mov    %edx,%eax
8010076a:	e8 a1 fc ff ff       	call   80100410 <consputc>
      break;
8010076f:	e9 70 ff ff ff       	jmp    801006e4 <cprintf+0x84>
80100774:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if((s = (char*)*argp++) == 0)
80100778:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010077b:	8b 10                	mov    (%eax),%edx
8010077d:	8d 48 04             	lea    0x4(%eax),%ecx
80100780:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80100783:	85 d2                	test   %edx,%edx
80100785:	74 49                	je     801007d0 <cprintf+0x170>
      for(; *s; s++)
80100787:	0f be 02             	movsbl (%edx),%eax
      if((s = (char*)*argp++) == 0)
8010078a:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
      for(; *s; s++)
8010078d:	84 c0                	test   %al,%al
8010078f:	0f 84 4f ff ff ff    	je     801006e4 <cprintf+0x84>
80100795:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80100798:	89 d3                	mov    %edx,%ebx
8010079a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801007a0:	83 c3 01             	add    $0x1,%ebx
        consputc(*s);
801007a3:	e8 68 fc ff ff       	call   80100410 <consputc>
      for(; *s; s++)
801007a8:	0f be 03             	movsbl (%ebx),%eax
801007ab:	84 c0                	test   %al,%al
801007ad:	75 f1                	jne    801007a0 <cprintf+0x140>
      if((s = (char*)*argp++) == 0)
801007af:	8b 45 e0             	mov    -0x20(%ebp),%eax
801007b2:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801007b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801007b8:	e9 27 ff ff ff       	jmp    801006e4 <cprintf+0x84>
801007bd:	8d 76 00             	lea    0x0(%esi),%esi
      consputc('%');
801007c0:	b8 25 00 00 00       	mov    $0x25,%eax
801007c5:	e8 46 fc ff ff       	call   80100410 <consputc>
      break;
801007ca:	e9 15 ff ff ff       	jmp    801006e4 <cprintf+0x84>
801007cf:	90                   	nop
        s = "(null)";
801007d0:	ba 58 83 10 80       	mov    $0x80108358,%edx
      for(; *s; s++)
801007d5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801007d8:	b8 28 00 00 00       	mov    $0x28,%eax
801007dd:	89 d3                	mov    %edx,%ebx
801007df:	eb bf                	jmp    801007a0 <cprintf+0x140>
801007e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801007e8:	83 ec 0c             	sub    $0xc,%esp
801007eb:	68 40 c5 10 80       	push   $0x8010c540
801007f0:	e8 1b 4e 00 00       	call   80105610 <acquire>
801007f5:	83 c4 10             	add    $0x10,%esp
801007f8:	e9 7c fe ff ff       	jmp    80100679 <cprintf+0x19>
    panic("null fmt");
801007fd:	83 ec 0c             	sub    $0xc,%esp
80100800:	68 5f 83 10 80       	push   $0x8010835f
80100805:	e8 86 fb ff ff       	call   80100390 <panic>
8010080a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100810 <consoleintr>:
{
80100810:	55                   	push   %ebp
80100811:	89 e5                	mov    %esp,%ebp
80100813:	57                   	push   %edi
80100814:	56                   	push   %esi
80100815:	53                   	push   %ebx
  int c, doprocdump = 0;
80100816:	31 f6                	xor    %esi,%esi
{
80100818:	83 ec 18             	sub    $0x18,%esp
8010081b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&cons.lock);
8010081e:	68 40 c5 10 80       	push   $0x8010c540
80100823:	e8 e8 4d 00 00       	call   80105610 <acquire>
  while((c = getc()) >= 0){
80100828:	83 c4 10             	add    $0x10,%esp
8010082b:	90                   	nop
8010082c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100830:	ff d3                	call   *%ebx
80100832:	85 c0                	test   %eax,%eax
80100834:	89 c7                	mov    %eax,%edi
80100836:	78 48                	js     80100880 <consoleintr+0x70>
    switch(c){
80100838:	83 ff 10             	cmp    $0x10,%edi
8010083b:	0f 84 e7 00 00 00    	je     80100928 <consoleintr+0x118>
80100841:	7e 5d                	jle    801008a0 <consoleintr+0x90>
80100843:	83 ff 15             	cmp    $0x15,%edi
80100846:	0f 84 ec 00 00 00    	je     80100938 <consoleintr+0x128>
8010084c:	83 ff 7f             	cmp    $0x7f,%edi
8010084f:	75 54                	jne    801008a5 <consoleintr+0x95>
      if(input.e != input.w){
80100851:	a1 c8 1f 11 80       	mov    0x80111fc8,%eax
80100856:	3b 05 c4 1f 11 80    	cmp    0x80111fc4,%eax
8010085c:	74 d2                	je     80100830 <consoleintr+0x20>
        input.e--;
8010085e:	83 e8 01             	sub    $0x1,%eax
80100861:	a3 c8 1f 11 80       	mov    %eax,0x80111fc8
        consputc(BACKSPACE);
80100866:	b8 00 01 00 00       	mov    $0x100,%eax
8010086b:	e8 a0 fb ff ff       	call   80100410 <consputc>
  while((c = getc()) >= 0){
80100870:	ff d3                	call   *%ebx
80100872:	85 c0                	test   %eax,%eax
80100874:	89 c7                	mov    %eax,%edi
80100876:	79 c0                	jns    80100838 <consoleintr+0x28>
80100878:	90                   	nop
80100879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
80100880:	83 ec 0c             	sub    $0xc,%esp
80100883:	68 40 c5 10 80       	push   $0x8010c540
80100888:	e8 43 4e 00 00       	call   801056d0 <release>
  if(doprocdump) {
8010088d:	83 c4 10             	add    $0x10,%esp
80100890:	85 f6                	test   %esi,%esi
80100892:	0f 85 f8 00 00 00    	jne    80100990 <consoleintr+0x180>
}
80100898:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010089b:	5b                   	pop    %ebx
8010089c:	5e                   	pop    %esi
8010089d:	5f                   	pop    %edi
8010089e:	5d                   	pop    %ebp
8010089f:	c3                   	ret    
    switch(c){
801008a0:	83 ff 08             	cmp    $0x8,%edi
801008a3:	74 ac                	je     80100851 <consoleintr+0x41>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008a5:	85 ff                	test   %edi,%edi
801008a7:	74 87                	je     80100830 <consoleintr+0x20>
801008a9:	a1 c8 1f 11 80       	mov    0x80111fc8,%eax
801008ae:	89 c2                	mov    %eax,%edx
801008b0:	2b 15 c0 1f 11 80    	sub    0x80111fc0,%edx
801008b6:	83 fa 7f             	cmp    $0x7f,%edx
801008b9:	0f 87 71 ff ff ff    	ja     80100830 <consoleintr+0x20>
801008bf:	8d 50 01             	lea    0x1(%eax),%edx
801008c2:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
801008c5:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
801008c8:	89 15 c8 1f 11 80    	mov    %edx,0x80111fc8
        c = (c == '\r') ? '\n' : c;
801008ce:	0f 84 cc 00 00 00    	je     801009a0 <consoleintr+0x190>
        input.buf[input.e++ % INPUT_BUF] = c;
801008d4:	89 f9                	mov    %edi,%ecx
801008d6:	88 88 40 1f 11 80    	mov    %cl,-0x7feee0c0(%eax)
        consputc(c);
801008dc:	89 f8                	mov    %edi,%eax
801008de:	e8 2d fb ff ff       	call   80100410 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008e3:	83 ff 0a             	cmp    $0xa,%edi
801008e6:	0f 84 c5 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008ec:	83 ff 04             	cmp    $0x4,%edi
801008ef:	0f 84 bc 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008f5:	a1 c0 1f 11 80       	mov    0x80111fc0,%eax
801008fa:	83 e8 80             	sub    $0xffffff80,%eax
801008fd:	39 05 c8 1f 11 80    	cmp    %eax,0x80111fc8
80100903:	0f 85 27 ff ff ff    	jne    80100830 <consoleintr+0x20>
          wakeup(&input.r);
80100909:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
8010090c:	a3 c4 1f 11 80       	mov    %eax,0x80111fc4
          wakeup(&input.r);
80100911:	68 c0 1f 11 80       	push   $0x80111fc0
80100916:	e8 95 46 00 00       	call   80104fb0 <wakeup>
8010091b:	83 c4 10             	add    $0x10,%esp
8010091e:	e9 0d ff ff ff       	jmp    80100830 <consoleintr+0x20>
80100923:	90                   	nop
80100924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      doprocdump = 1;
80100928:	be 01 00 00 00       	mov    $0x1,%esi
8010092d:	e9 fe fe ff ff       	jmp    80100830 <consoleintr+0x20>
80100932:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80100938:	a1 c8 1f 11 80       	mov    0x80111fc8,%eax
8010093d:	39 05 c4 1f 11 80    	cmp    %eax,0x80111fc4
80100943:	75 2b                	jne    80100970 <consoleintr+0x160>
80100945:	e9 e6 fe ff ff       	jmp    80100830 <consoleintr+0x20>
8010094a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        input.e--;
80100950:	a3 c8 1f 11 80       	mov    %eax,0x80111fc8
        consputc(BACKSPACE);
80100955:	b8 00 01 00 00       	mov    $0x100,%eax
8010095a:	e8 b1 fa ff ff       	call   80100410 <consputc>
      while(input.e != input.w &&
8010095f:	a1 c8 1f 11 80       	mov    0x80111fc8,%eax
80100964:	3b 05 c4 1f 11 80    	cmp    0x80111fc4,%eax
8010096a:	0f 84 c0 fe ff ff    	je     80100830 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100970:	83 e8 01             	sub    $0x1,%eax
80100973:	89 c2                	mov    %eax,%edx
80100975:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100978:	80 ba 40 1f 11 80 0a 	cmpb   $0xa,-0x7feee0c0(%edx)
8010097f:	75 cf                	jne    80100950 <consoleintr+0x140>
80100981:	e9 aa fe ff ff       	jmp    80100830 <consoleintr+0x20>
80100986:	8d 76 00             	lea    0x0(%esi),%esi
80100989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
}
80100990:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100993:	5b                   	pop    %ebx
80100994:	5e                   	pop    %esi
80100995:	5f                   	pop    %edi
80100996:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100997:	e9 f4 46 00 00       	jmp    80105090 <procdump>
8010099c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        input.buf[input.e++ % INPUT_BUF] = c;
801009a0:	c6 80 40 1f 11 80 0a 	movb   $0xa,-0x7feee0c0(%eax)
        consputc(c);
801009a7:	b8 0a 00 00 00       	mov    $0xa,%eax
801009ac:	e8 5f fa ff ff       	call   80100410 <consputc>
801009b1:	a1 c8 1f 11 80       	mov    0x80111fc8,%eax
801009b6:	e9 4e ff ff ff       	jmp    80100909 <consoleintr+0xf9>
801009bb:	90                   	nop
801009bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801009c0 <consoleinit>:

void
consoleinit(void)
{
801009c0:	55                   	push   %ebp
801009c1:	89 e5                	mov    %esp,%ebp
801009c3:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
801009c6:	68 68 83 10 80       	push   $0x80108368
801009cb:	68 40 c5 10 80       	push   $0x8010c540
801009d0:	e8 fb 4a 00 00       	call   801054d0 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
801009d5:	58                   	pop    %eax
801009d6:	5a                   	pop    %edx
801009d7:	6a 00                	push   $0x0
801009d9:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
801009db:	c7 05 8c 29 11 80 00 	movl   $0x80100600,0x8011298c
801009e2:	06 10 80 
  devsw[CONSOLE].read = consoleread;
801009e5:	c7 05 88 29 11 80 70 	movl   $0x80100270,0x80112988
801009ec:	02 10 80 
  cons.locking = 1;
801009ef:	c7 05 74 c5 10 80 01 	movl   $0x1,0x8010c574
801009f6:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
801009f9:	e8 d2 18 00 00       	call   801022d0 <ioapicenable>
}
801009fe:	83 c4 10             	add    $0x10,%esp
80100a01:	c9                   	leave  
80100a02:	c3                   	ret    
80100a03:	66 90                	xchg   %ax,%ax
80100a05:	66 90                	xchg   %ax,%ax
80100a07:	66 90                	xchg   %ax,%ax
80100a09:	66 90                	xchg   %ax,%ax
80100a0b:	66 90                	xchg   %ax,%ax
80100a0d:	66 90                	xchg   %ax,%ax
80100a0f:	90                   	nop

80100a10 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100a10:	55                   	push   %ebp
80100a11:	89 e5                	mov    %esp,%ebp
80100a13:	57                   	push   %edi
80100a14:	56                   	push   %esi
80100a15:	53                   	push   %ebx
80100a16:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100a1c:	e8 7f 2e 00 00       	call   801038a0 <myproc>
80100a21:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

  begin_op();
80100a27:	e8 74 21 00 00       	call   80102ba0 <begin_op>

  if((ip = namei(path)) == 0){
80100a2c:	83 ec 0c             	sub    $0xc,%esp
80100a2f:	ff 75 08             	pushl  0x8(%ebp)
80100a32:	e8 a9 14 00 00       	call   80101ee0 <namei>
80100a37:	83 c4 10             	add    $0x10,%esp
80100a3a:	85 c0                	test   %eax,%eax
80100a3c:	0f 84 91 01 00 00    	je     80100bd3 <exec+0x1c3>
    end_op();
    cprintf("\nexec: fail\n");
    return -1;
  }
  ilock(ip);
80100a42:	83 ec 0c             	sub    $0xc,%esp
80100a45:	89 c3                	mov    %eax,%ebx
80100a47:	50                   	push   %eax
80100a48:	e8 33 0c 00 00       	call   80101680 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100a4d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100a53:	6a 34                	push   $0x34
80100a55:	6a 00                	push   $0x0
80100a57:	50                   	push   %eax
80100a58:	53                   	push   %ebx
80100a59:	e8 02 0f 00 00       	call   80101960 <readi>
80100a5e:	83 c4 20             	add    $0x20,%esp
80100a61:	83 f8 34             	cmp    $0x34,%eax
80100a64:	74 22                	je     80100a88 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100a66:	83 ec 0c             	sub    $0xc,%esp
80100a69:	53                   	push   %ebx
80100a6a:	e8 a1 0e 00 00       	call   80101910 <iunlockput>
    end_op();
80100a6f:	e8 9c 21 00 00       	call   80102c10 <end_op>
80100a74:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100a77:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a7f:	5b                   	pop    %ebx
80100a80:	5e                   	pop    %esi
80100a81:	5f                   	pop    %edi
80100a82:	5d                   	pop    %ebp
80100a83:	c3                   	ret    
80100a84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100a88:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a8f:	45 4c 46 
80100a92:	75 d2                	jne    80100a66 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80100a94:	e8 c7 75 00 00       	call   80108060 <setupkvm>
80100a99:	85 c0                	test   %eax,%eax
80100a9b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100aa1:	74 c3                	je     80100a66 <exec+0x56>
  sz = 0;
80100aa3:	31 ff                	xor    %edi,%edi
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100aa5:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100aac:	00 
80100aad:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
80100ab3:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100ab9:	0f 84 8c 02 00 00    	je     80100d4b <exec+0x33b>
80100abf:	31 f6                	xor    %esi,%esi
80100ac1:	eb 7f                	jmp    80100b42 <exec+0x132>
80100ac3:	90                   	nop
80100ac4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ph.type != ELF_PROG_LOAD)
80100ac8:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100acf:	75 63                	jne    80100b34 <exec+0x124>
    if(ph.memsz < ph.filesz)
80100ad1:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100ad7:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100add:	0f 82 86 00 00 00    	jb     80100b69 <exec+0x159>
80100ae3:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100ae9:	72 7e                	jb     80100b69 <exec+0x159>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100aeb:	83 ec 04             	sub    $0x4,%esp
80100aee:	50                   	push   %eax
80100aef:	57                   	push   %edi
80100af0:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100af6:	e8 85 73 00 00       	call   80107e80 <allocuvm>
80100afb:	83 c4 10             	add    $0x10,%esp
80100afe:	85 c0                	test   %eax,%eax
80100b00:	89 c7                	mov    %eax,%edi
80100b02:	74 65                	je     80100b69 <exec+0x159>
    if(ph.vaddr % PGSIZE != 0)
80100b04:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b0a:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b0f:	75 58                	jne    80100b69 <exec+0x159>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b11:	83 ec 0c             	sub    $0xc,%esp
80100b14:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b1a:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100b20:	53                   	push   %ebx
80100b21:	50                   	push   %eax
80100b22:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b28:	e8 93 72 00 00       	call   80107dc0 <loaduvm>
80100b2d:	83 c4 20             	add    $0x20,%esp
80100b30:	85 c0                	test   %eax,%eax
80100b32:	78 35                	js     80100b69 <exec+0x159>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b34:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100b3b:	83 c6 01             	add    $0x1,%esi
80100b3e:	39 f0                	cmp    %esi,%eax
80100b40:	7e 3d                	jle    80100b7f <exec+0x16f>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100b42:	89 f0                	mov    %esi,%eax
80100b44:	6a 20                	push   $0x20
80100b46:	c1 e0 05             	shl    $0x5,%eax
80100b49:	03 85 ec fe ff ff    	add    -0x114(%ebp),%eax
80100b4f:	50                   	push   %eax
80100b50:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100b56:	50                   	push   %eax
80100b57:	53                   	push   %ebx
80100b58:	e8 03 0e 00 00       	call   80101960 <readi>
80100b5d:	83 c4 10             	add    $0x10,%esp
80100b60:	83 f8 20             	cmp    $0x20,%eax
80100b63:	0f 84 5f ff ff ff    	je     80100ac8 <exec+0xb8>
    freevm(pgdir);
80100b69:	83 ec 0c             	sub    $0xc,%esp
80100b6c:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b72:	e8 69 74 00 00       	call   80107fe0 <freevm>
80100b77:	83 c4 10             	add    $0x10,%esp
80100b7a:	e9 e7 fe ff ff       	jmp    80100a66 <exec+0x56>
80100b7f:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100b85:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100b8b:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100b91:	83 ec 0c             	sub    $0xc,%esp
80100b94:	53                   	push   %ebx
80100b95:	e8 76 0d 00 00       	call   80101910 <iunlockput>
  end_op();
80100b9a:	e8 71 20 00 00       	call   80102c10 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b9f:	83 c4 0c             	add    $0xc,%esp
80100ba2:	56                   	push   %esi
80100ba3:	57                   	push   %edi
80100ba4:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100baa:	e8 d1 72 00 00       	call   80107e80 <allocuvm>
80100baf:	83 c4 10             	add    $0x10,%esp
80100bb2:	85 c0                	test   %eax,%eax
80100bb4:	89 c6                	mov    %eax,%esi
80100bb6:	75 3a                	jne    80100bf2 <exec+0x1e2>
    freevm(pgdir);
80100bb8:	83 ec 0c             	sub    $0xc,%esp
80100bbb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100bc1:	e8 1a 74 00 00       	call   80107fe0 <freevm>
80100bc6:	83 c4 10             	add    $0x10,%esp
  return -1;
80100bc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bce:	e9 a9 fe ff ff       	jmp    80100a7c <exec+0x6c>
    end_op();
80100bd3:	e8 38 20 00 00       	call   80102c10 <end_op>
    cprintf("\nexec: fail\n");
80100bd8:	83 ec 0c             	sub    $0xc,%esp
80100bdb:	68 81 83 10 80       	push   $0x80108381
80100be0:	e8 7b fa ff ff       	call   80100660 <cprintf>
    return -1;
80100be5:	83 c4 10             	add    $0x10,%esp
80100be8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bed:	e9 8a fe ff ff       	jmp    80100a7c <exec+0x6c>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bf2:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100bf8:	83 ec 08             	sub    $0x8,%esp
  for(argc = 0; argv[argc]; argc++) {
80100bfb:	31 ff                	xor    %edi,%edi
80100bfd:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bff:	50                   	push   %eax
80100c00:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100c06:	e8 f5 74 00 00       	call   80108100 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c0b:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c0e:	83 c4 10             	add    $0x10,%esp
80100c11:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c17:	8b 00                	mov    (%eax),%eax
80100c19:	85 c0                	test   %eax,%eax
80100c1b:	74 70                	je     80100c8d <exec+0x27d>
80100c1d:	89 b5 ec fe ff ff    	mov    %esi,-0x114(%ebp)
80100c23:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100c29:	eb 0a                	jmp    80100c35 <exec+0x225>
80100c2b:	90                   	nop
80100c2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(argc >= MAXARG)
80100c30:	83 ff 20             	cmp    $0x20,%edi
80100c33:	74 83                	je     80100bb8 <exec+0x1a8>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c35:	83 ec 0c             	sub    $0xc,%esp
80100c38:	50                   	push   %eax
80100c39:	e8 02 4d 00 00       	call   80105940 <strlen>
80100c3e:	f7 d0                	not    %eax
80100c40:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c42:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c45:	5a                   	pop    %edx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c46:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c49:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c4c:	e8 ef 4c 00 00       	call   80105940 <strlen>
80100c51:	83 c0 01             	add    $0x1,%eax
80100c54:	50                   	push   %eax
80100c55:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c58:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c5b:	53                   	push   %ebx
80100c5c:	56                   	push   %esi
80100c5d:	e8 fe 75 00 00       	call   80108260 <copyout>
80100c62:	83 c4 20             	add    $0x20,%esp
80100c65:	85 c0                	test   %eax,%eax
80100c67:	0f 88 4b ff ff ff    	js     80100bb8 <exec+0x1a8>
  for(argc = 0; argv[argc]; argc++) {
80100c6d:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100c70:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100c77:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100c7a:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100c80:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100c83:	85 c0                	test   %eax,%eax
80100c85:	75 a9                	jne    80100c30 <exec+0x220>
80100c87:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c8d:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100c94:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100c96:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100c9d:	00 00 00 00 
  ustack[0] = 0xffffffff;  // fake return PC
80100ca1:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100ca8:	ff ff ff 
  ustack[1] = argc;
80100cab:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cb1:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100cb3:	83 c0 0c             	add    $0xc,%eax
80100cb6:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cb8:	50                   	push   %eax
80100cb9:	52                   	push   %edx
80100cba:	53                   	push   %ebx
80100cbb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cc1:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cc7:	e8 94 75 00 00       	call   80108260 <copyout>
80100ccc:	83 c4 10             	add    $0x10,%esp
80100ccf:	85 c0                	test   %eax,%eax
80100cd1:	0f 88 e1 fe ff ff    	js     80100bb8 <exec+0x1a8>
  for(last=s=path; *s; s++)
80100cd7:	8b 45 08             	mov    0x8(%ebp),%eax
80100cda:	0f b6 00             	movzbl (%eax),%eax
80100cdd:	84 c0                	test   %al,%al
80100cdf:	74 17                	je     80100cf8 <exec+0x2e8>
80100ce1:	8b 55 08             	mov    0x8(%ebp),%edx
80100ce4:	89 d1                	mov    %edx,%ecx
80100ce6:	83 c1 01             	add    $0x1,%ecx
80100ce9:	3c 2f                	cmp    $0x2f,%al
80100ceb:	0f b6 01             	movzbl (%ecx),%eax
80100cee:	0f 44 d1             	cmove  %ecx,%edx
80100cf1:	84 c0                	test   %al,%al
80100cf3:	75 f1                	jne    80100ce6 <exec+0x2d6>
80100cf5:	89 55 08             	mov    %edx,0x8(%ebp)
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100cf8:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100cfe:	50                   	push   %eax
80100cff:	6a 10                	push   $0x10
80100d01:	ff 75 08             	pushl  0x8(%ebp)
80100d04:	89 f8                	mov    %edi,%eax
80100d06:	83 c0 6c             	add    $0x6c,%eax
80100d09:	50                   	push   %eax
80100d0a:	e8 f1 4b 00 00       	call   80105900 <safestrcpy>
  curproc->pgdir = pgdir;
80100d0f:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  oldpgdir = curproc->pgdir;
80100d15:	89 f9                	mov    %edi,%ecx
80100d17:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->tf->eip = elf.entry;  // main
80100d1a:	8b 41 18             	mov    0x18(%ecx),%eax
  curproc->sz = sz;
80100d1d:	89 31                	mov    %esi,(%ecx)
  curproc->pgdir = pgdir;
80100d1f:	89 51 04             	mov    %edx,0x4(%ecx)
  curproc->tf->eip = elf.entry;  // main
80100d22:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d28:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d2b:	8b 41 18             	mov    0x18(%ecx),%eax
80100d2e:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100d31:	89 0c 24             	mov    %ecx,(%esp)
80100d34:	e8 f7 6e 00 00       	call   80107c30 <switchuvm>
  freevm(oldpgdir);
80100d39:	89 3c 24             	mov    %edi,(%esp)
80100d3c:	e8 9f 72 00 00       	call   80107fe0 <freevm>
  return 0;
80100d41:	83 c4 10             	add    $0x10,%esp
80100d44:	31 c0                	xor    %eax,%eax
80100d46:	e9 31 fd ff ff       	jmp    80100a7c <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d4b:	be 00 20 00 00       	mov    $0x2000,%esi
80100d50:	e9 3c fe ff ff       	jmp    80100b91 <exec+0x181>
80100d55:	66 90                	xchg   %ax,%ax
80100d57:	66 90                	xchg   %ax,%ax
80100d59:	66 90                	xchg   %ax,%ax
80100d5b:	66 90                	xchg   %ax,%ax
80100d5d:	66 90                	xchg   %ax,%ax
80100d5f:	90                   	nop

80100d60 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100d60:	55                   	push   %ebp
80100d61:	89 e5                	mov    %esp,%ebp
80100d63:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100d66:	68 8e 83 10 80       	push   $0x8010838e
80100d6b:	68 e0 1f 11 80       	push   $0x80111fe0
80100d70:	e8 5b 47 00 00       	call   801054d0 <initlock>
}
80100d75:	83 c4 10             	add    $0x10,%esp
80100d78:	c9                   	leave  
80100d79:	c3                   	ret    
80100d7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100d80 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d80:	55                   	push   %ebp
80100d81:	89 e5                	mov    %esp,%ebp
80100d83:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d84:	bb 14 20 11 80       	mov    $0x80112014,%ebx
{
80100d89:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100d8c:	68 e0 1f 11 80       	push   $0x80111fe0
80100d91:	e8 7a 48 00 00       	call   80105610 <acquire>
80100d96:	83 c4 10             	add    $0x10,%esp
80100d99:	eb 10                	jmp    80100dab <filealloc+0x2b>
80100d9b:	90                   	nop
80100d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100da0:	83 c3 18             	add    $0x18,%ebx
80100da3:	81 fb 74 29 11 80    	cmp    $0x80112974,%ebx
80100da9:	73 25                	jae    80100dd0 <filealloc+0x50>
    if(f->ref == 0){
80100dab:	8b 43 04             	mov    0x4(%ebx),%eax
80100dae:	85 c0                	test   %eax,%eax
80100db0:	75 ee                	jne    80100da0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100db2:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100db5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100dbc:	68 e0 1f 11 80       	push   $0x80111fe0
80100dc1:	e8 0a 49 00 00       	call   801056d0 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100dc6:	89 d8                	mov    %ebx,%eax
      return f;
80100dc8:	83 c4 10             	add    $0x10,%esp
}
80100dcb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100dce:	c9                   	leave  
80100dcf:	c3                   	ret    
  release(&ftable.lock);
80100dd0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100dd3:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100dd5:	68 e0 1f 11 80       	push   $0x80111fe0
80100dda:	e8 f1 48 00 00       	call   801056d0 <release>
}
80100ddf:	89 d8                	mov    %ebx,%eax
  return 0;
80100de1:	83 c4 10             	add    $0x10,%esp
}
80100de4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100de7:	c9                   	leave  
80100de8:	c3                   	ret    
80100de9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100df0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100df0:	55                   	push   %ebp
80100df1:	89 e5                	mov    %esp,%ebp
80100df3:	53                   	push   %ebx
80100df4:	83 ec 10             	sub    $0x10,%esp
80100df7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100dfa:	68 e0 1f 11 80       	push   $0x80111fe0
80100dff:	e8 0c 48 00 00       	call   80105610 <acquire>
  if(f->ref < 1)
80100e04:	8b 43 04             	mov    0x4(%ebx),%eax
80100e07:	83 c4 10             	add    $0x10,%esp
80100e0a:	85 c0                	test   %eax,%eax
80100e0c:	7e 1a                	jle    80100e28 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100e0e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100e11:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100e14:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e17:	68 e0 1f 11 80       	push   $0x80111fe0
80100e1c:	e8 af 48 00 00       	call   801056d0 <release>
  return f;
}
80100e21:	89 d8                	mov    %ebx,%eax
80100e23:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e26:	c9                   	leave  
80100e27:	c3                   	ret    
    panic("filedup");
80100e28:	83 ec 0c             	sub    $0xc,%esp
80100e2b:	68 95 83 10 80       	push   $0x80108395
80100e30:	e8 5b f5 ff ff       	call   80100390 <panic>
80100e35:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e40 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100e40:	55                   	push   %ebp
80100e41:	89 e5                	mov    %esp,%ebp
80100e43:	57                   	push   %edi
80100e44:	56                   	push   %esi
80100e45:	53                   	push   %ebx
80100e46:	83 ec 28             	sub    $0x28,%esp
80100e49:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100e4c:	68 e0 1f 11 80       	push   $0x80111fe0
80100e51:	e8 ba 47 00 00       	call   80105610 <acquire>
  if(f->ref < 1)
80100e56:	8b 43 04             	mov    0x4(%ebx),%eax
80100e59:	83 c4 10             	add    $0x10,%esp
80100e5c:	85 c0                	test   %eax,%eax
80100e5e:	0f 8e 9b 00 00 00    	jle    80100eff <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
80100e64:	83 e8 01             	sub    $0x1,%eax
80100e67:	85 c0                	test   %eax,%eax
80100e69:	89 43 04             	mov    %eax,0x4(%ebx)
80100e6c:	74 1a                	je     80100e88 <fileclose+0x48>
    release(&ftable.lock);
80100e6e:	c7 45 08 e0 1f 11 80 	movl   $0x80111fe0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e75:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100e78:	5b                   	pop    %ebx
80100e79:	5e                   	pop    %esi
80100e7a:	5f                   	pop    %edi
80100e7b:	5d                   	pop    %ebp
    release(&ftable.lock);
80100e7c:	e9 4f 48 00 00       	jmp    801056d0 <release>
80100e81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  ff = *f;
80100e88:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
80100e8c:	8b 3b                	mov    (%ebx),%edi
  release(&ftable.lock);
80100e8e:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100e91:	8b 73 0c             	mov    0xc(%ebx),%esi
  f->type = FD_NONE;
80100e94:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100e9a:	88 45 e7             	mov    %al,-0x19(%ebp)
80100e9d:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100ea0:	68 e0 1f 11 80       	push   $0x80111fe0
  ff = *f;
80100ea5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100ea8:	e8 23 48 00 00       	call   801056d0 <release>
  if(ff.type == FD_PIPE)
80100ead:	83 c4 10             	add    $0x10,%esp
80100eb0:	83 ff 01             	cmp    $0x1,%edi
80100eb3:	74 13                	je     80100ec8 <fileclose+0x88>
  else if(ff.type == FD_INODE){
80100eb5:	83 ff 02             	cmp    $0x2,%edi
80100eb8:	74 26                	je     80100ee0 <fileclose+0xa0>
}
80100eba:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ebd:	5b                   	pop    %ebx
80100ebe:	5e                   	pop    %esi
80100ebf:	5f                   	pop    %edi
80100ec0:	5d                   	pop    %ebp
80100ec1:	c3                   	ret    
80100ec2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pipeclose(ff.pipe, ff.writable);
80100ec8:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100ecc:	83 ec 08             	sub    $0x8,%esp
80100ecf:	53                   	push   %ebx
80100ed0:	56                   	push   %esi
80100ed1:	e8 7a 24 00 00       	call   80103350 <pipeclose>
80100ed6:	83 c4 10             	add    $0x10,%esp
80100ed9:	eb df                	jmp    80100eba <fileclose+0x7a>
80100edb:	90                   	nop
80100edc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    begin_op();
80100ee0:	e8 bb 1c 00 00       	call   80102ba0 <begin_op>
    iput(ff.ip);
80100ee5:	83 ec 0c             	sub    $0xc,%esp
80100ee8:	ff 75 e0             	pushl  -0x20(%ebp)
80100eeb:	e8 c0 08 00 00       	call   801017b0 <iput>
    end_op();
80100ef0:	83 c4 10             	add    $0x10,%esp
}
80100ef3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ef6:	5b                   	pop    %ebx
80100ef7:	5e                   	pop    %esi
80100ef8:	5f                   	pop    %edi
80100ef9:	5d                   	pop    %ebp
    end_op();
80100efa:	e9 11 1d 00 00       	jmp    80102c10 <end_op>
    panic("fileclose");
80100eff:	83 ec 0c             	sub    $0xc,%esp
80100f02:	68 9d 83 10 80       	push   $0x8010839d
80100f07:	e8 84 f4 ff ff       	call   80100390 <panic>
80100f0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f10 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100f10:	55                   	push   %ebp
80100f11:	89 e5                	mov    %esp,%ebp
80100f13:	53                   	push   %ebx
80100f14:	83 ec 04             	sub    $0x4,%esp
80100f17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100f1a:	83 3b 02             	cmpl   $0x2,(%ebx)
80100f1d:	75 31                	jne    80100f50 <filestat+0x40>
    ilock(f->ip);
80100f1f:	83 ec 0c             	sub    $0xc,%esp
80100f22:	ff 73 10             	pushl  0x10(%ebx)
80100f25:	e8 56 07 00 00       	call   80101680 <ilock>
    stati(f->ip, st);
80100f2a:	58                   	pop    %eax
80100f2b:	5a                   	pop    %edx
80100f2c:	ff 75 0c             	pushl  0xc(%ebp)
80100f2f:	ff 73 10             	pushl  0x10(%ebx)
80100f32:	e8 f9 09 00 00       	call   80101930 <stati>
    iunlock(f->ip);
80100f37:	59                   	pop    %ecx
80100f38:	ff 73 10             	pushl  0x10(%ebx)
80100f3b:	e8 20 08 00 00       	call   80101760 <iunlock>
    return 0;
80100f40:	83 c4 10             	add    $0x10,%esp
80100f43:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100f45:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f48:	c9                   	leave  
80100f49:	c3                   	ret    
80100f4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return -1;
80100f50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100f55:	eb ee                	jmp    80100f45 <filestat+0x35>
80100f57:	89 f6                	mov    %esi,%esi
80100f59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100f60 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100f60:	55                   	push   %ebp
80100f61:	89 e5                	mov    %esp,%ebp
80100f63:	57                   	push   %edi
80100f64:	56                   	push   %esi
80100f65:	53                   	push   %ebx
80100f66:	83 ec 0c             	sub    $0xc,%esp
80100f69:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f6c:	8b 75 0c             	mov    0xc(%ebp),%esi
80100f6f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100f72:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100f76:	74 60                	je     80100fd8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80100f78:	8b 03                	mov    (%ebx),%eax
80100f7a:	83 f8 01             	cmp    $0x1,%eax
80100f7d:	74 41                	je     80100fc0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100f7f:	83 f8 02             	cmp    $0x2,%eax
80100f82:	75 5b                	jne    80100fdf <fileread+0x7f>
    ilock(f->ip);
80100f84:	83 ec 0c             	sub    $0xc,%esp
80100f87:	ff 73 10             	pushl  0x10(%ebx)
80100f8a:	e8 f1 06 00 00       	call   80101680 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f8f:	57                   	push   %edi
80100f90:	ff 73 14             	pushl  0x14(%ebx)
80100f93:	56                   	push   %esi
80100f94:	ff 73 10             	pushl  0x10(%ebx)
80100f97:	e8 c4 09 00 00       	call   80101960 <readi>
80100f9c:	83 c4 20             	add    $0x20,%esp
80100f9f:	85 c0                	test   %eax,%eax
80100fa1:	89 c6                	mov    %eax,%esi
80100fa3:	7e 03                	jle    80100fa8 <fileread+0x48>
      f->off += r;
80100fa5:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100fa8:	83 ec 0c             	sub    $0xc,%esp
80100fab:	ff 73 10             	pushl  0x10(%ebx)
80100fae:	e8 ad 07 00 00       	call   80101760 <iunlock>
    return r;
80100fb3:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80100fb6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fb9:	89 f0                	mov    %esi,%eax
80100fbb:	5b                   	pop    %ebx
80100fbc:	5e                   	pop    %esi
80100fbd:	5f                   	pop    %edi
80100fbe:	5d                   	pop    %ebp
80100fbf:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80100fc0:	8b 43 0c             	mov    0xc(%ebx),%eax
80100fc3:	89 45 08             	mov    %eax,0x8(%ebp)
}
80100fc6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fc9:	5b                   	pop    %ebx
80100fca:	5e                   	pop    %esi
80100fcb:	5f                   	pop    %edi
80100fcc:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
80100fcd:	e9 2e 25 00 00       	jmp    80103500 <piperead>
80100fd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80100fd8:	be ff ff ff ff       	mov    $0xffffffff,%esi
80100fdd:	eb d7                	jmp    80100fb6 <fileread+0x56>
  panic("fileread");
80100fdf:	83 ec 0c             	sub    $0xc,%esp
80100fe2:	68 a7 83 10 80       	push   $0x801083a7
80100fe7:	e8 a4 f3 ff ff       	call   80100390 <panic>
80100fec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100ff0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100ff0:	55                   	push   %ebp
80100ff1:	89 e5                	mov    %esp,%ebp
80100ff3:	57                   	push   %edi
80100ff4:	56                   	push   %esi
80100ff5:	53                   	push   %ebx
80100ff6:	83 ec 1c             	sub    $0x1c,%esp
80100ff9:	8b 75 08             	mov    0x8(%ebp),%esi
80100ffc:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
80100fff:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
80101003:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101006:	8b 45 10             	mov    0x10(%ebp),%eax
80101009:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
8010100c:	0f 84 aa 00 00 00    	je     801010bc <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
80101012:	8b 06                	mov    (%esi),%eax
80101014:	83 f8 01             	cmp    $0x1,%eax
80101017:	0f 84 c3 00 00 00    	je     801010e0 <filewrite+0xf0>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010101d:	83 f8 02             	cmp    $0x2,%eax
80101020:	0f 85 d9 00 00 00    	jne    801010ff <filewrite+0x10f>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101026:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101029:	31 ff                	xor    %edi,%edi
    while(i < n){
8010102b:	85 c0                	test   %eax,%eax
8010102d:	7f 34                	jg     80101063 <filewrite+0x73>
8010102f:	e9 9c 00 00 00       	jmp    801010d0 <filewrite+0xe0>
80101034:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101038:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
8010103b:	83 ec 0c             	sub    $0xc,%esp
8010103e:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
80101041:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101044:	e8 17 07 00 00       	call   80101760 <iunlock>
      end_op();
80101049:	e8 c2 1b 00 00       	call   80102c10 <end_op>
8010104e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101051:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
80101054:	39 c3                	cmp    %eax,%ebx
80101056:	0f 85 96 00 00 00    	jne    801010f2 <filewrite+0x102>
        panic("short filewrite");
      i += r;
8010105c:	01 df                	add    %ebx,%edi
    while(i < n){
8010105e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101061:	7e 6d                	jle    801010d0 <filewrite+0xe0>
      int n1 = n - i;
80101063:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101066:	b8 00 06 00 00       	mov    $0x600,%eax
8010106b:	29 fb                	sub    %edi,%ebx
8010106d:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101073:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
80101076:	e8 25 1b 00 00       	call   80102ba0 <begin_op>
      ilock(f->ip);
8010107b:	83 ec 0c             	sub    $0xc,%esp
8010107e:	ff 76 10             	pushl  0x10(%esi)
80101081:	e8 fa 05 00 00       	call   80101680 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101086:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101089:	53                   	push   %ebx
8010108a:	ff 76 14             	pushl  0x14(%esi)
8010108d:	01 f8                	add    %edi,%eax
8010108f:	50                   	push   %eax
80101090:	ff 76 10             	pushl  0x10(%esi)
80101093:	e8 c8 09 00 00       	call   80101a60 <writei>
80101098:	83 c4 20             	add    $0x20,%esp
8010109b:	85 c0                	test   %eax,%eax
8010109d:	7f 99                	jg     80101038 <filewrite+0x48>
      iunlock(f->ip);
8010109f:	83 ec 0c             	sub    $0xc,%esp
801010a2:	ff 76 10             	pushl  0x10(%esi)
801010a5:	89 45 e0             	mov    %eax,-0x20(%ebp)
801010a8:	e8 b3 06 00 00       	call   80101760 <iunlock>
      end_op();
801010ad:	e8 5e 1b 00 00       	call   80102c10 <end_op>
      if(r < 0)
801010b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010b5:	83 c4 10             	add    $0x10,%esp
801010b8:	85 c0                	test   %eax,%eax
801010ba:	74 98                	je     80101054 <filewrite+0x64>
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801010bf:	bf ff ff ff ff       	mov    $0xffffffff,%edi
}
801010c4:	89 f8                	mov    %edi,%eax
801010c6:	5b                   	pop    %ebx
801010c7:	5e                   	pop    %esi
801010c8:	5f                   	pop    %edi
801010c9:	5d                   	pop    %ebp
801010ca:	c3                   	ret    
801010cb:	90                   	nop
801010cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return i == n ? n : -1;
801010d0:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801010d3:	75 e7                	jne    801010bc <filewrite+0xcc>
}
801010d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010d8:	89 f8                	mov    %edi,%eax
801010da:	5b                   	pop    %ebx
801010db:	5e                   	pop    %esi
801010dc:	5f                   	pop    %edi
801010dd:	5d                   	pop    %ebp
801010de:	c3                   	ret    
801010df:	90                   	nop
    return pipewrite(f->pipe, addr, n);
801010e0:	8b 46 0c             	mov    0xc(%esi),%eax
801010e3:	89 45 08             	mov    %eax,0x8(%ebp)
}
801010e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010e9:	5b                   	pop    %ebx
801010ea:	5e                   	pop    %esi
801010eb:	5f                   	pop    %edi
801010ec:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801010ed:	e9 fe 22 00 00       	jmp    801033f0 <pipewrite>
        panic("short filewrite");
801010f2:	83 ec 0c             	sub    $0xc,%esp
801010f5:	68 b0 83 10 80       	push   $0x801083b0
801010fa:	e8 91 f2 ff ff       	call   80100390 <panic>
  panic("filewrite");
801010ff:	83 ec 0c             	sub    $0xc,%esp
80101102:	68 b6 83 10 80       	push   $0x801083b6
80101107:	e8 84 f2 ff ff       	call   80100390 <panic>
8010110c:	66 90                	xchg   %ax,%ax
8010110e:	66 90                	xchg   %ax,%ax

80101110 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101110:	55                   	push   %ebp
80101111:	89 e5                	mov    %esp,%ebp
80101113:	56                   	push   %esi
80101114:	53                   	push   %ebx
80101115:	89 d3                	mov    %edx,%ebx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
80101117:	c1 ea 0c             	shr    $0xc,%edx
8010111a:	03 15 f8 29 11 80    	add    0x801129f8,%edx
80101120:	83 ec 08             	sub    $0x8,%esp
80101123:	52                   	push   %edx
80101124:	50                   	push   %eax
80101125:	e8 a6 ef ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
8010112a:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
8010112c:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
8010112f:	ba 01 00 00 00       	mov    $0x1,%edx
80101134:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
80101137:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
8010113d:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
80101140:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101142:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101147:	85 d1                	test   %edx,%ecx
80101149:	74 25                	je     80101170 <bfree+0x60>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
8010114b:	f7 d2                	not    %edx
8010114d:	89 c6                	mov    %eax,%esi
  log_write(bp);
8010114f:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101152:	21 ca                	and    %ecx,%edx
80101154:	88 54 1e 5c          	mov    %dl,0x5c(%esi,%ebx,1)
  log_write(bp);
80101158:	56                   	push   %esi
80101159:	e8 12 1c 00 00       	call   80102d70 <log_write>
  brelse(bp);
8010115e:	89 34 24             	mov    %esi,(%esp)
80101161:	e8 7a f0 ff ff       	call   801001e0 <brelse>
}
80101166:	83 c4 10             	add    $0x10,%esp
80101169:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010116c:	5b                   	pop    %ebx
8010116d:	5e                   	pop    %esi
8010116e:	5d                   	pop    %ebp
8010116f:	c3                   	ret    
    panic("freeing free block");
80101170:	83 ec 0c             	sub    $0xc,%esp
80101173:	68 c0 83 10 80       	push   $0x801083c0
80101178:	e8 13 f2 ff ff       	call   80100390 <panic>
8010117d:	8d 76 00             	lea    0x0(%esi),%esi

80101180 <balloc>:
{
80101180:	55                   	push   %ebp
80101181:	89 e5                	mov    %esp,%ebp
80101183:	57                   	push   %edi
80101184:	56                   	push   %esi
80101185:	53                   	push   %ebx
80101186:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101189:	8b 0d e0 29 11 80    	mov    0x801129e0,%ecx
{
8010118f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101192:	85 c9                	test   %ecx,%ecx
80101194:	0f 84 87 00 00 00    	je     80101221 <balloc+0xa1>
8010119a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
801011a1:	8b 75 dc             	mov    -0x24(%ebp),%esi
801011a4:	83 ec 08             	sub    $0x8,%esp
801011a7:	89 f0                	mov    %esi,%eax
801011a9:	c1 f8 0c             	sar    $0xc,%eax
801011ac:	03 05 f8 29 11 80    	add    0x801129f8,%eax
801011b2:	50                   	push   %eax
801011b3:	ff 75 d8             	pushl  -0x28(%ebp)
801011b6:	e8 15 ef ff ff       	call   801000d0 <bread>
801011bb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801011be:	a1 e0 29 11 80       	mov    0x801129e0,%eax
801011c3:	83 c4 10             	add    $0x10,%esp
801011c6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801011c9:	31 c0                	xor    %eax,%eax
801011cb:	eb 2f                	jmp    801011fc <balloc+0x7c>
801011cd:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
801011d0:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801011d2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
801011d5:	bb 01 00 00 00       	mov    $0x1,%ebx
801011da:	83 e1 07             	and    $0x7,%ecx
801011dd:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801011df:	89 c1                	mov    %eax,%ecx
801011e1:	c1 f9 03             	sar    $0x3,%ecx
801011e4:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
801011e9:	85 df                	test   %ebx,%edi
801011eb:	89 fa                	mov    %edi,%edx
801011ed:	74 41                	je     80101230 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801011ef:	83 c0 01             	add    $0x1,%eax
801011f2:	83 c6 01             	add    $0x1,%esi
801011f5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801011fa:	74 05                	je     80101201 <balloc+0x81>
801011fc:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801011ff:	77 cf                	ja     801011d0 <balloc+0x50>
    brelse(bp);
80101201:	83 ec 0c             	sub    $0xc,%esp
80101204:	ff 75 e4             	pushl  -0x1c(%ebp)
80101207:	e8 d4 ef ff ff       	call   801001e0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010120c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101213:	83 c4 10             	add    $0x10,%esp
80101216:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101219:	39 05 e0 29 11 80    	cmp    %eax,0x801129e0
8010121f:	77 80                	ja     801011a1 <balloc+0x21>
  panic("balloc: out of blocks");
80101221:	83 ec 0c             	sub    $0xc,%esp
80101224:	68 d3 83 10 80       	push   $0x801083d3
80101229:	e8 62 f1 ff ff       	call   80100390 <panic>
8010122e:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101230:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101233:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101236:	09 da                	or     %ebx,%edx
80101238:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010123c:	57                   	push   %edi
8010123d:	e8 2e 1b 00 00       	call   80102d70 <log_write>
        brelse(bp);
80101242:	89 3c 24             	mov    %edi,(%esp)
80101245:	e8 96 ef ff ff       	call   801001e0 <brelse>
  bp = bread(dev, bno);
8010124a:	58                   	pop    %eax
8010124b:	5a                   	pop    %edx
8010124c:	56                   	push   %esi
8010124d:	ff 75 d8             	pushl  -0x28(%ebp)
80101250:	e8 7b ee ff ff       	call   801000d0 <bread>
80101255:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101257:	8d 40 5c             	lea    0x5c(%eax),%eax
8010125a:	83 c4 0c             	add    $0xc,%esp
8010125d:	68 00 02 00 00       	push   $0x200
80101262:	6a 00                	push   $0x0
80101264:	50                   	push   %eax
80101265:	e8 b6 44 00 00       	call   80105720 <memset>
  log_write(bp);
8010126a:	89 1c 24             	mov    %ebx,(%esp)
8010126d:	e8 fe 1a 00 00       	call   80102d70 <log_write>
  brelse(bp);
80101272:	89 1c 24             	mov    %ebx,(%esp)
80101275:	e8 66 ef ff ff       	call   801001e0 <brelse>
}
8010127a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010127d:	89 f0                	mov    %esi,%eax
8010127f:	5b                   	pop    %ebx
80101280:	5e                   	pop    %esi
80101281:	5f                   	pop    %edi
80101282:	5d                   	pop    %ebp
80101283:	c3                   	ret    
80101284:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010128a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101290 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101290:	55                   	push   %ebp
80101291:	89 e5                	mov    %esp,%ebp
80101293:	57                   	push   %edi
80101294:	56                   	push   %esi
80101295:	53                   	push   %ebx
80101296:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101298:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010129a:	bb 34 2a 11 80       	mov    $0x80112a34,%ebx
{
8010129f:	83 ec 28             	sub    $0x28,%esp
801012a2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
801012a5:	68 00 2a 11 80       	push   $0x80112a00
801012aa:	e8 61 43 00 00       	call   80105610 <acquire>
801012af:	83 c4 10             	add    $0x10,%esp
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012b2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801012b5:	eb 17                	jmp    801012ce <iget+0x3e>
801012b7:	89 f6                	mov    %esi,%esi
801012b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801012c0:	81 c3 90 00 00 00    	add    $0x90,%ebx
801012c6:	81 fb 54 46 11 80    	cmp    $0x80114654,%ebx
801012cc:	73 22                	jae    801012f0 <iget+0x60>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801012ce:	8b 4b 08             	mov    0x8(%ebx),%ecx
801012d1:	85 c9                	test   %ecx,%ecx
801012d3:	7e 04                	jle    801012d9 <iget+0x49>
801012d5:	39 3b                	cmp    %edi,(%ebx)
801012d7:	74 4f                	je     80101328 <iget+0x98>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801012d9:	85 f6                	test   %esi,%esi
801012db:	75 e3                	jne    801012c0 <iget+0x30>
801012dd:	85 c9                	test   %ecx,%ecx
801012df:	0f 44 f3             	cmove  %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012e2:	81 c3 90 00 00 00    	add    $0x90,%ebx
801012e8:	81 fb 54 46 11 80    	cmp    $0x80114654,%ebx
801012ee:	72 de                	jb     801012ce <iget+0x3e>
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801012f0:	85 f6                	test   %esi,%esi
801012f2:	74 5b                	je     8010134f <iget+0xbf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801012f4:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801012f7:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801012f9:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801012fc:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
80101303:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
8010130a:	68 00 2a 11 80       	push   $0x80112a00
8010130f:	e8 bc 43 00 00       	call   801056d0 <release>

  return ip;
80101314:	83 c4 10             	add    $0x10,%esp
}
80101317:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010131a:	89 f0                	mov    %esi,%eax
8010131c:	5b                   	pop    %ebx
8010131d:	5e                   	pop    %esi
8010131e:	5f                   	pop    %edi
8010131f:	5d                   	pop    %ebp
80101320:	c3                   	ret    
80101321:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101328:	39 53 04             	cmp    %edx,0x4(%ebx)
8010132b:	75 ac                	jne    801012d9 <iget+0x49>
      release(&icache.lock);
8010132d:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101330:	83 c1 01             	add    $0x1,%ecx
      return ip;
80101333:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
80101335:	68 00 2a 11 80       	push   $0x80112a00
      ip->ref++;
8010133a:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
8010133d:	e8 8e 43 00 00       	call   801056d0 <release>
      return ip;
80101342:	83 c4 10             	add    $0x10,%esp
}
80101345:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101348:	89 f0                	mov    %esi,%eax
8010134a:	5b                   	pop    %ebx
8010134b:	5e                   	pop    %esi
8010134c:	5f                   	pop    %edi
8010134d:	5d                   	pop    %ebp
8010134e:	c3                   	ret    
    panic("iget: no inodes");
8010134f:	83 ec 0c             	sub    $0xc,%esp
80101352:	68 e9 83 10 80       	push   $0x801083e9
80101357:	e8 34 f0 ff ff       	call   80100390 <panic>
8010135c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101360 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101360:	55                   	push   %ebp
80101361:	89 e5                	mov    %esp,%ebp
80101363:	57                   	push   %edi
80101364:	56                   	push   %esi
80101365:	53                   	push   %ebx
80101366:	89 c6                	mov    %eax,%esi
80101368:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010136b:	83 fa 0b             	cmp    $0xb,%edx
8010136e:	77 18                	ja     80101388 <bmap+0x28>
80101370:	8d 3c 90             	lea    (%eax,%edx,4),%edi
    if((addr = ip->addrs[bn]) == 0)
80101373:	8b 5f 5c             	mov    0x5c(%edi),%ebx
80101376:	85 db                	test   %ebx,%ebx
80101378:	74 76                	je     801013f0 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010137a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010137d:	89 d8                	mov    %ebx,%eax
8010137f:	5b                   	pop    %ebx
80101380:	5e                   	pop    %esi
80101381:	5f                   	pop    %edi
80101382:	5d                   	pop    %ebp
80101383:	c3                   	ret    
80101384:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bn -= NDIRECT;
80101388:	8d 5a f4             	lea    -0xc(%edx),%ebx
  if(bn < NINDIRECT){
8010138b:	83 fb 7f             	cmp    $0x7f,%ebx
8010138e:	0f 87 90 00 00 00    	ja     80101424 <bmap+0xc4>
    if((addr = ip->addrs[NDIRECT]) == 0)
80101394:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
8010139a:	8b 00                	mov    (%eax),%eax
8010139c:	85 d2                	test   %edx,%edx
8010139e:	74 70                	je     80101410 <bmap+0xb0>
    bp = bread(ip->dev, addr);
801013a0:	83 ec 08             	sub    $0x8,%esp
801013a3:	52                   	push   %edx
801013a4:	50                   	push   %eax
801013a5:	e8 26 ed ff ff       	call   801000d0 <bread>
    if((addr = a[bn]) == 0){
801013aa:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
801013ae:	83 c4 10             	add    $0x10,%esp
    bp = bread(ip->dev, addr);
801013b1:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
801013b3:	8b 1a                	mov    (%edx),%ebx
801013b5:	85 db                	test   %ebx,%ebx
801013b7:	75 1d                	jne    801013d6 <bmap+0x76>
      a[bn] = addr = balloc(ip->dev);
801013b9:	8b 06                	mov    (%esi),%eax
801013bb:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801013be:	e8 bd fd ff ff       	call   80101180 <balloc>
801013c3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
801013c6:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801013c9:	89 c3                	mov    %eax,%ebx
801013cb:	89 02                	mov    %eax,(%edx)
      log_write(bp);
801013cd:	57                   	push   %edi
801013ce:	e8 9d 19 00 00       	call   80102d70 <log_write>
801013d3:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
801013d6:	83 ec 0c             	sub    $0xc,%esp
801013d9:	57                   	push   %edi
801013da:	e8 01 ee ff ff       	call   801001e0 <brelse>
801013df:	83 c4 10             	add    $0x10,%esp
}
801013e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013e5:	89 d8                	mov    %ebx,%eax
801013e7:	5b                   	pop    %ebx
801013e8:	5e                   	pop    %esi
801013e9:	5f                   	pop    %edi
801013ea:	5d                   	pop    %ebp
801013eb:	c3                   	ret    
801013ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ip->addrs[bn] = addr = balloc(ip->dev);
801013f0:	8b 00                	mov    (%eax),%eax
801013f2:	e8 89 fd ff ff       	call   80101180 <balloc>
801013f7:	89 47 5c             	mov    %eax,0x5c(%edi)
}
801013fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
      ip->addrs[bn] = addr = balloc(ip->dev);
801013fd:	89 c3                	mov    %eax,%ebx
}
801013ff:	89 d8                	mov    %ebx,%eax
80101401:	5b                   	pop    %ebx
80101402:	5e                   	pop    %esi
80101403:	5f                   	pop    %edi
80101404:	5d                   	pop    %ebp
80101405:	c3                   	ret    
80101406:	8d 76 00             	lea    0x0(%esi),%esi
80101409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101410:	e8 6b fd ff ff       	call   80101180 <balloc>
80101415:	89 c2                	mov    %eax,%edx
80101417:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
8010141d:	8b 06                	mov    (%esi),%eax
8010141f:	e9 7c ff ff ff       	jmp    801013a0 <bmap+0x40>
  panic("bmap: out of range");
80101424:	83 ec 0c             	sub    $0xc,%esp
80101427:	68 f9 83 10 80       	push   $0x801083f9
8010142c:	e8 5f ef ff ff       	call   80100390 <panic>
80101431:	eb 0d                	jmp    80101440 <readsb>
80101433:	90                   	nop
80101434:	90                   	nop
80101435:	90                   	nop
80101436:	90                   	nop
80101437:	90                   	nop
80101438:	90                   	nop
80101439:	90                   	nop
8010143a:	90                   	nop
8010143b:	90                   	nop
8010143c:	90                   	nop
8010143d:	90                   	nop
8010143e:	90                   	nop
8010143f:	90                   	nop

80101440 <readsb>:
{
80101440:	55                   	push   %ebp
80101441:	89 e5                	mov    %esp,%ebp
80101443:	56                   	push   %esi
80101444:	53                   	push   %ebx
80101445:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101448:	83 ec 08             	sub    $0x8,%esp
8010144b:	6a 01                	push   $0x1
8010144d:	ff 75 08             	pushl  0x8(%ebp)
80101450:	e8 7b ec ff ff       	call   801000d0 <bread>
80101455:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101457:	8d 40 5c             	lea    0x5c(%eax),%eax
8010145a:	83 c4 0c             	add    $0xc,%esp
8010145d:	6a 1c                	push   $0x1c
8010145f:	50                   	push   %eax
80101460:	56                   	push   %esi
80101461:	e8 6a 43 00 00       	call   801057d0 <memmove>
  brelse(bp);
80101466:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101469:	83 c4 10             	add    $0x10,%esp
}
8010146c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010146f:	5b                   	pop    %ebx
80101470:	5e                   	pop    %esi
80101471:	5d                   	pop    %ebp
  brelse(bp);
80101472:	e9 69 ed ff ff       	jmp    801001e0 <brelse>
80101477:	89 f6                	mov    %esi,%esi
80101479:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101480 <iinit>:
{
80101480:	55                   	push   %ebp
80101481:	89 e5                	mov    %esp,%ebp
80101483:	53                   	push   %ebx
80101484:	bb 40 2a 11 80       	mov    $0x80112a40,%ebx
80101489:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010148c:	68 0c 84 10 80       	push   $0x8010840c
80101491:	68 00 2a 11 80       	push   $0x80112a00
80101496:	e8 35 40 00 00       	call   801054d0 <initlock>
8010149b:	83 c4 10             	add    $0x10,%esp
8010149e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
801014a0:	83 ec 08             	sub    $0x8,%esp
801014a3:	68 13 84 10 80       	push   $0x80108413
801014a8:	53                   	push   %ebx
801014a9:	81 c3 90 00 00 00    	add    $0x90,%ebx
801014af:	e8 ec 3e 00 00       	call   801053a0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801014b4:	83 c4 10             	add    $0x10,%esp
801014b7:	81 fb 60 46 11 80    	cmp    $0x80114660,%ebx
801014bd:	75 e1                	jne    801014a0 <iinit+0x20>
  readsb(dev, &sb);
801014bf:	83 ec 08             	sub    $0x8,%esp
801014c2:	68 e0 29 11 80       	push   $0x801129e0
801014c7:	ff 75 08             	pushl  0x8(%ebp)
801014ca:	e8 71 ff ff ff       	call   80101440 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801014cf:	ff 35 f8 29 11 80    	pushl  0x801129f8
801014d5:	ff 35 f4 29 11 80    	pushl  0x801129f4
801014db:	ff 35 f0 29 11 80    	pushl  0x801129f0
801014e1:	ff 35 ec 29 11 80    	pushl  0x801129ec
801014e7:	ff 35 e8 29 11 80    	pushl  0x801129e8
801014ed:	ff 35 e4 29 11 80    	pushl  0x801129e4
801014f3:	ff 35 e0 29 11 80    	pushl  0x801129e0
801014f9:	68 78 84 10 80       	push   $0x80108478
801014fe:	e8 5d f1 ff ff       	call   80100660 <cprintf>
}
80101503:	83 c4 30             	add    $0x30,%esp
80101506:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101509:	c9                   	leave  
8010150a:	c3                   	ret    
8010150b:	90                   	nop
8010150c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101510 <ialloc>:
{
80101510:	55                   	push   %ebp
80101511:	89 e5                	mov    %esp,%ebp
80101513:	57                   	push   %edi
80101514:	56                   	push   %esi
80101515:	53                   	push   %ebx
80101516:	83 ec 1c             	sub    $0x1c,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101519:	83 3d e8 29 11 80 01 	cmpl   $0x1,0x801129e8
{
80101520:	8b 45 0c             	mov    0xc(%ebp),%eax
80101523:	8b 75 08             	mov    0x8(%ebp),%esi
80101526:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101529:	0f 86 91 00 00 00    	jbe    801015c0 <ialloc+0xb0>
8010152f:	bb 01 00 00 00       	mov    $0x1,%ebx
80101534:	eb 21                	jmp    80101557 <ialloc+0x47>
80101536:	8d 76 00             	lea    0x0(%esi),%esi
80101539:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    brelse(bp);
80101540:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101543:	83 c3 01             	add    $0x1,%ebx
    brelse(bp);
80101546:	57                   	push   %edi
80101547:	e8 94 ec ff ff       	call   801001e0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010154c:	83 c4 10             	add    $0x10,%esp
8010154f:	39 1d e8 29 11 80    	cmp    %ebx,0x801129e8
80101555:	76 69                	jbe    801015c0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101557:	89 d8                	mov    %ebx,%eax
80101559:	83 ec 08             	sub    $0x8,%esp
8010155c:	c1 e8 03             	shr    $0x3,%eax
8010155f:	03 05 f4 29 11 80    	add    0x801129f4,%eax
80101565:	50                   	push   %eax
80101566:	56                   	push   %esi
80101567:	e8 64 eb ff ff       	call   801000d0 <bread>
8010156c:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
8010156e:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
80101570:	83 c4 10             	add    $0x10,%esp
    dip = (struct dinode*)bp->data + inum%IPB;
80101573:	83 e0 07             	and    $0x7,%eax
80101576:	c1 e0 06             	shl    $0x6,%eax
80101579:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010157d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101581:	75 bd                	jne    80101540 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101583:	83 ec 04             	sub    $0x4,%esp
80101586:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101589:	6a 40                	push   $0x40
8010158b:	6a 00                	push   $0x0
8010158d:	51                   	push   %ecx
8010158e:	e8 8d 41 00 00       	call   80105720 <memset>
      dip->type = type;
80101593:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101597:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010159a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010159d:	89 3c 24             	mov    %edi,(%esp)
801015a0:	e8 cb 17 00 00       	call   80102d70 <log_write>
      brelse(bp);
801015a5:	89 3c 24             	mov    %edi,(%esp)
801015a8:	e8 33 ec ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
801015ad:	83 c4 10             	add    $0x10,%esp
}
801015b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801015b3:	89 da                	mov    %ebx,%edx
801015b5:	89 f0                	mov    %esi,%eax
}
801015b7:	5b                   	pop    %ebx
801015b8:	5e                   	pop    %esi
801015b9:	5f                   	pop    %edi
801015ba:	5d                   	pop    %ebp
      return iget(dev, inum);
801015bb:	e9 d0 fc ff ff       	jmp    80101290 <iget>
  panic("ialloc: no inodes");
801015c0:	83 ec 0c             	sub    $0xc,%esp
801015c3:	68 19 84 10 80       	push   $0x80108419
801015c8:	e8 c3 ed ff ff       	call   80100390 <panic>
801015cd:	8d 76 00             	lea    0x0(%esi),%esi

801015d0 <iupdate>:
{
801015d0:	55                   	push   %ebp
801015d1:	89 e5                	mov    %esp,%ebp
801015d3:	56                   	push   %esi
801015d4:	53                   	push   %ebx
801015d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015d8:	83 ec 08             	sub    $0x8,%esp
801015db:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015de:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015e1:	c1 e8 03             	shr    $0x3,%eax
801015e4:	03 05 f4 29 11 80    	add    0x801129f4,%eax
801015ea:	50                   	push   %eax
801015eb:	ff 73 a4             	pushl  -0x5c(%ebx)
801015ee:	e8 dd ea ff ff       	call   801000d0 <bread>
801015f3:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801015f5:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
801015f8:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015fc:	83 c4 0c             	add    $0xc,%esp
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801015ff:	83 e0 07             	and    $0x7,%eax
80101602:	c1 e0 06             	shl    $0x6,%eax
80101605:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101609:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010160c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101610:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101613:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101617:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010161b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010161f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101623:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101627:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010162a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010162d:	6a 34                	push   $0x34
8010162f:	53                   	push   %ebx
80101630:	50                   	push   %eax
80101631:	e8 9a 41 00 00       	call   801057d0 <memmove>
  log_write(bp);
80101636:	89 34 24             	mov    %esi,(%esp)
80101639:	e8 32 17 00 00       	call   80102d70 <log_write>
  brelse(bp);
8010163e:	89 75 08             	mov    %esi,0x8(%ebp)
80101641:	83 c4 10             	add    $0x10,%esp
}
80101644:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101647:	5b                   	pop    %ebx
80101648:	5e                   	pop    %esi
80101649:	5d                   	pop    %ebp
  brelse(bp);
8010164a:	e9 91 eb ff ff       	jmp    801001e0 <brelse>
8010164f:	90                   	nop

80101650 <idup>:
{
80101650:	55                   	push   %ebp
80101651:	89 e5                	mov    %esp,%ebp
80101653:	53                   	push   %ebx
80101654:	83 ec 10             	sub    $0x10,%esp
80101657:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010165a:	68 00 2a 11 80       	push   $0x80112a00
8010165f:	e8 ac 3f 00 00       	call   80105610 <acquire>
  ip->ref++;
80101664:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101668:	c7 04 24 00 2a 11 80 	movl   $0x80112a00,(%esp)
8010166f:	e8 5c 40 00 00       	call   801056d0 <release>
}
80101674:	89 d8                	mov    %ebx,%eax
80101676:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101679:	c9                   	leave  
8010167a:	c3                   	ret    
8010167b:	90                   	nop
8010167c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101680 <ilock>:
{
80101680:	55                   	push   %ebp
80101681:	89 e5                	mov    %esp,%ebp
80101683:	56                   	push   %esi
80101684:	53                   	push   %ebx
80101685:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101688:	85 db                	test   %ebx,%ebx
8010168a:	0f 84 b7 00 00 00    	je     80101747 <ilock+0xc7>
80101690:	8b 53 08             	mov    0x8(%ebx),%edx
80101693:	85 d2                	test   %edx,%edx
80101695:	0f 8e ac 00 00 00    	jle    80101747 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010169b:	8d 43 0c             	lea    0xc(%ebx),%eax
8010169e:	83 ec 0c             	sub    $0xc,%esp
801016a1:	50                   	push   %eax
801016a2:	e8 39 3d 00 00       	call   801053e0 <acquiresleep>
  if(ip->valid == 0){
801016a7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801016aa:	83 c4 10             	add    $0x10,%esp
801016ad:	85 c0                	test   %eax,%eax
801016af:	74 0f                	je     801016c0 <ilock+0x40>
}
801016b1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801016b4:	5b                   	pop    %ebx
801016b5:	5e                   	pop    %esi
801016b6:	5d                   	pop    %ebp
801016b7:	c3                   	ret    
801016b8:	90                   	nop
801016b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016c0:	8b 43 04             	mov    0x4(%ebx),%eax
801016c3:	83 ec 08             	sub    $0x8,%esp
801016c6:	c1 e8 03             	shr    $0x3,%eax
801016c9:	03 05 f4 29 11 80    	add    0x801129f4,%eax
801016cf:	50                   	push   %eax
801016d0:	ff 33                	pushl  (%ebx)
801016d2:	e8 f9 e9 ff ff       	call   801000d0 <bread>
801016d7:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801016d9:	8b 43 04             	mov    0x4(%ebx),%eax
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016dc:	83 c4 0c             	add    $0xc,%esp
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801016df:	83 e0 07             	and    $0x7,%eax
801016e2:	c1 e0 06             	shl    $0x6,%eax
801016e5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801016e9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016ec:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801016ef:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801016f3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801016f7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801016fb:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801016ff:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101703:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101707:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010170b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010170e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101711:	6a 34                	push   $0x34
80101713:	50                   	push   %eax
80101714:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101717:	50                   	push   %eax
80101718:	e8 b3 40 00 00       	call   801057d0 <memmove>
    brelse(bp);
8010171d:	89 34 24             	mov    %esi,(%esp)
80101720:	e8 bb ea ff ff       	call   801001e0 <brelse>
    if(ip->type == 0)
80101725:	83 c4 10             	add    $0x10,%esp
80101728:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010172d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101734:	0f 85 77 ff ff ff    	jne    801016b1 <ilock+0x31>
      panic("ilock: no type");
8010173a:	83 ec 0c             	sub    $0xc,%esp
8010173d:	68 31 84 10 80       	push   $0x80108431
80101742:	e8 49 ec ff ff       	call   80100390 <panic>
    panic("ilock");
80101747:	83 ec 0c             	sub    $0xc,%esp
8010174a:	68 2b 84 10 80       	push   $0x8010842b
8010174f:	e8 3c ec ff ff       	call   80100390 <panic>
80101754:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010175a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101760 <iunlock>:
{
80101760:	55                   	push   %ebp
80101761:	89 e5                	mov    %esp,%ebp
80101763:	56                   	push   %esi
80101764:	53                   	push   %ebx
80101765:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101768:	85 db                	test   %ebx,%ebx
8010176a:	74 28                	je     80101794 <iunlock+0x34>
8010176c:	8d 73 0c             	lea    0xc(%ebx),%esi
8010176f:	83 ec 0c             	sub    $0xc,%esp
80101772:	56                   	push   %esi
80101773:	e8 08 3d 00 00       	call   80105480 <holdingsleep>
80101778:	83 c4 10             	add    $0x10,%esp
8010177b:	85 c0                	test   %eax,%eax
8010177d:	74 15                	je     80101794 <iunlock+0x34>
8010177f:	8b 43 08             	mov    0x8(%ebx),%eax
80101782:	85 c0                	test   %eax,%eax
80101784:	7e 0e                	jle    80101794 <iunlock+0x34>
  releasesleep(&ip->lock);
80101786:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101789:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010178c:	5b                   	pop    %ebx
8010178d:	5e                   	pop    %esi
8010178e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
8010178f:	e9 ac 3c 00 00       	jmp    80105440 <releasesleep>
    panic("iunlock");
80101794:	83 ec 0c             	sub    $0xc,%esp
80101797:	68 40 84 10 80       	push   $0x80108440
8010179c:	e8 ef eb ff ff       	call   80100390 <panic>
801017a1:	eb 0d                	jmp    801017b0 <iput>
801017a3:	90                   	nop
801017a4:	90                   	nop
801017a5:	90                   	nop
801017a6:	90                   	nop
801017a7:	90                   	nop
801017a8:	90                   	nop
801017a9:	90                   	nop
801017aa:	90                   	nop
801017ab:	90                   	nop
801017ac:	90                   	nop
801017ad:	90                   	nop
801017ae:	90                   	nop
801017af:	90                   	nop

801017b0 <iput>:
{
801017b0:	55                   	push   %ebp
801017b1:	89 e5                	mov    %esp,%ebp
801017b3:	57                   	push   %edi
801017b4:	56                   	push   %esi
801017b5:	53                   	push   %ebx
801017b6:	83 ec 28             	sub    $0x28,%esp
801017b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801017bc:	8d 7b 0c             	lea    0xc(%ebx),%edi
801017bf:	57                   	push   %edi
801017c0:	e8 1b 3c 00 00       	call   801053e0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801017c5:	8b 53 4c             	mov    0x4c(%ebx),%edx
801017c8:	83 c4 10             	add    $0x10,%esp
801017cb:	85 d2                	test   %edx,%edx
801017cd:	74 07                	je     801017d6 <iput+0x26>
801017cf:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801017d4:	74 32                	je     80101808 <iput+0x58>
  releasesleep(&ip->lock);
801017d6:	83 ec 0c             	sub    $0xc,%esp
801017d9:	57                   	push   %edi
801017da:	e8 61 3c 00 00       	call   80105440 <releasesleep>
  acquire(&icache.lock);
801017df:	c7 04 24 00 2a 11 80 	movl   $0x80112a00,(%esp)
801017e6:	e8 25 3e 00 00       	call   80105610 <acquire>
  ip->ref--;
801017eb:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801017ef:	83 c4 10             	add    $0x10,%esp
801017f2:	c7 45 08 00 2a 11 80 	movl   $0x80112a00,0x8(%ebp)
}
801017f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801017fc:	5b                   	pop    %ebx
801017fd:	5e                   	pop    %esi
801017fe:	5f                   	pop    %edi
801017ff:	5d                   	pop    %ebp
  release(&icache.lock);
80101800:	e9 cb 3e 00 00       	jmp    801056d0 <release>
80101805:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101808:	83 ec 0c             	sub    $0xc,%esp
8010180b:	68 00 2a 11 80       	push   $0x80112a00
80101810:	e8 fb 3d 00 00       	call   80105610 <acquire>
    int r = ip->ref;
80101815:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101818:	c7 04 24 00 2a 11 80 	movl   $0x80112a00,(%esp)
8010181f:	e8 ac 3e 00 00       	call   801056d0 <release>
    if(r == 1){
80101824:	83 c4 10             	add    $0x10,%esp
80101827:	83 fe 01             	cmp    $0x1,%esi
8010182a:	75 aa                	jne    801017d6 <iput+0x26>
8010182c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101832:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101835:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101838:	89 cf                	mov    %ecx,%edi
8010183a:	eb 0b                	jmp    80101847 <iput+0x97>
8010183c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101840:	83 c6 04             	add    $0x4,%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101843:	39 fe                	cmp    %edi,%esi
80101845:	74 19                	je     80101860 <iput+0xb0>
    if(ip->addrs[i]){
80101847:	8b 16                	mov    (%esi),%edx
80101849:	85 d2                	test   %edx,%edx
8010184b:	74 f3                	je     80101840 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010184d:	8b 03                	mov    (%ebx),%eax
8010184f:	e8 bc f8 ff ff       	call   80101110 <bfree>
      ip->addrs[i] = 0;
80101854:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010185a:	eb e4                	jmp    80101840 <iput+0x90>
8010185c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101860:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101866:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101869:	85 c0                	test   %eax,%eax
8010186b:	75 33                	jne    801018a0 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010186d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101870:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101877:	53                   	push   %ebx
80101878:	e8 53 fd ff ff       	call   801015d0 <iupdate>
      ip->type = 0;
8010187d:	31 c0                	xor    %eax,%eax
8010187f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101883:	89 1c 24             	mov    %ebx,(%esp)
80101886:	e8 45 fd ff ff       	call   801015d0 <iupdate>
      ip->valid = 0;
8010188b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101892:	83 c4 10             	add    $0x10,%esp
80101895:	e9 3c ff ff ff       	jmp    801017d6 <iput+0x26>
8010189a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018a0:	83 ec 08             	sub    $0x8,%esp
801018a3:	50                   	push   %eax
801018a4:	ff 33                	pushl  (%ebx)
801018a6:	e8 25 e8 ff ff       	call   801000d0 <bread>
801018ab:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801018b1:	89 7d e0             	mov    %edi,-0x20(%ebp)
801018b4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
801018b7:	8d 70 5c             	lea    0x5c(%eax),%esi
801018ba:	83 c4 10             	add    $0x10,%esp
801018bd:	89 cf                	mov    %ecx,%edi
801018bf:	eb 0e                	jmp    801018cf <iput+0x11f>
801018c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018c8:	83 c6 04             	add    $0x4,%esi
    for(j = 0; j < NINDIRECT; j++){
801018cb:	39 fe                	cmp    %edi,%esi
801018cd:	74 0f                	je     801018de <iput+0x12e>
      if(a[j])
801018cf:	8b 16                	mov    (%esi),%edx
801018d1:	85 d2                	test   %edx,%edx
801018d3:	74 f3                	je     801018c8 <iput+0x118>
        bfree(ip->dev, a[j]);
801018d5:	8b 03                	mov    (%ebx),%eax
801018d7:	e8 34 f8 ff ff       	call   80101110 <bfree>
801018dc:	eb ea                	jmp    801018c8 <iput+0x118>
    brelse(bp);
801018de:	83 ec 0c             	sub    $0xc,%esp
801018e1:	ff 75 e4             	pushl  -0x1c(%ebp)
801018e4:	8b 7d e0             	mov    -0x20(%ebp),%edi
801018e7:	e8 f4 e8 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801018ec:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
801018f2:	8b 03                	mov    (%ebx),%eax
801018f4:	e8 17 f8 ff ff       	call   80101110 <bfree>
    ip->addrs[NDIRECT] = 0;
801018f9:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101900:	00 00 00 
80101903:	83 c4 10             	add    $0x10,%esp
80101906:	e9 62 ff ff ff       	jmp    8010186d <iput+0xbd>
8010190b:	90                   	nop
8010190c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101910 <iunlockput>:
{
80101910:	55                   	push   %ebp
80101911:	89 e5                	mov    %esp,%ebp
80101913:	53                   	push   %ebx
80101914:	83 ec 10             	sub    $0x10,%esp
80101917:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
8010191a:	53                   	push   %ebx
8010191b:	e8 40 fe ff ff       	call   80101760 <iunlock>
  iput(ip);
80101920:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101923:	83 c4 10             	add    $0x10,%esp
}
80101926:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101929:	c9                   	leave  
  iput(ip);
8010192a:	e9 81 fe ff ff       	jmp    801017b0 <iput>
8010192f:	90                   	nop

80101930 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101930:	55                   	push   %ebp
80101931:	89 e5                	mov    %esp,%ebp
80101933:	8b 55 08             	mov    0x8(%ebp),%edx
80101936:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101939:	8b 0a                	mov    (%edx),%ecx
8010193b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010193e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101941:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101944:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101948:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
8010194b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010194f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101953:	8b 52 58             	mov    0x58(%edx),%edx
80101956:	89 50 10             	mov    %edx,0x10(%eax)
}
80101959:	5d                   	pop    %ebp
8010195a:	c3                   	ret    
8010195b:	90                   	nop
8010195c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101960 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101960:	55                   	push   %ebp
80101961:	89 e5                	mov    %esp,%ebp
80101963:	57                   	push   %edi
80101964:	56                   	push   %esi
80101965:	53                   	push   %ebx
80101966:	83 ec 1c             	sub    $0x1c,%esp
80101969:	8b 45 08             	mov    0x8(%ebp),%eax
8010196c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010196f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101972:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101977:	89 75 e0             	mov    %esi,-0x20(%ebp)
8010197a:	89 45 d8             	mov    %eax,-0x28(%ebp)
8010197d:	8b 75 10             	mov    0x10(%ebp),%esi
80101980:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101983:	0f 84 a7 00 00 00    	je     80101a30 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101989:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010198c:	8b 40 58             	mov    0x58(%eax),%eax
8010198f:	39 c6                	cmp    %eax,%esi
80101991:	0f 87 ba 00 00 00    	ja     80101a51 <readi+0xf1>
80101997:	8b 7d e4             	mov    -0x1c(%ebp),%edi
8010199a:	89 f9                	mov    %edi,%ecx
8010199c:	01 f1                	add    %esi,%ecx
8010199e:	0f 82 ad 00 00 00    	jb     80101a51 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
801019a4:	89 c2                	mov    %eax,%edx
801019a6:	29 f2                	sub    %esi,%edx
801019a8:	39 c8                	cmp    %ecx,%eax
801019aa:	0f 43 d7             	cmovae %edi,%edx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019ad:	31 ff                	xor    %edi,%edi
801019af:	85 d2                	test   %edx,%edx
    n = ip->size - off;
801019b1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019b4:	74 6c                	je     80101a22 <readi+0xc2>
801019b6:	8d 76 00             	lea    0x0(%esi),%esi
801019b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019c0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
801019c3:	89 f2                	mov    %esi,%edx
801019c5:	c1 ea 09             	shr    $0x9,%edx
801019c8:	89 d8                	mov    %ebx,%eax
801019ca:	e8 91 f9 ff ff       	call   80101360 <bmap>
801019cf:	83 ec 08             	sub    $0x8,%esp
801019d2:	50                   	push   %eax
801019d3:	ff 33                	pushl  (%ebx)
801019d5:	e8 f6 e6 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
801019da:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019dd:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
801019df:	89 f0                	mov    %esi,%eax
801019e1:	25 ff 01 00 00       	and    $0x1ff,%eax
801019e6:	b9 00 02 00 00       	mov    $0x200,%ecx
801019eb:	83 c4 0c             	add    $0xc,%esp
801019ee:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
801019f0:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
801019f4:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
801019f7:	29 fb                	sub    %edi,%ebx
801019f9:	39 d9                	cmp    %ebx,%ecx
801019fb:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
801019fe:	53                   	push   %ebx
801019ff:	50                   	push   %eax
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a00:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80101a02:	ff 75 e0             	pushl  -0x20(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a05:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101a07:	e8 c4 3d 00 00       	call   801057d0 <memmove>
    brelse(bp);
80101a0c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101a0f:	89 14 24             	mov    %edx,(%esp)
80101a12:	e8 c9 e7 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a17:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101a1a:	83 c4 10             	add    $0x10,%esp
80101a1d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101a20:	77 9e                	ja     801019c0 <readi+0x60>
  }
  return n;
80101a22:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101a25:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a28:	5b                   	pop    %ebx
80101a29:	5e                   	pop    %esi
80101a2a:	5f                   	pop    %edi
80101a2b:	5d                   	pop    %ebp
80101a2c:	c3                   	ret    
80101a2d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101a30:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101a34:	66 83 f8 09          	cmp    $0x9,%ax
80101a38:	77 17                	ja     80101a51 <readi+0xf1>
80101a3a:	8b 04 c5 80 29 11 80 	mov    -0x7feed680(,%eax,8),%eax
80101a41:	85 c0                	test   %eax,%eax
80101a43:	74 0c                	je     80101a51 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101a45:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101a48:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a4b:	5b                   	pop    %ebx
80101a4c:	5e                   	pop    %esi
80101a4d:	5f                   	pop    %edi
80101a4e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101a4f:	ff e0                	jmp    *%eax
      return -1;
80101a51:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a56:	eb cd                	jmp    80101a25 <readi+0xc5>
80101a58:	90                   	nop
80101a59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101a60 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a60:	55                   	push   %ebp
80101a61:	89 e5                	mov    %esp,%ebp
80101a63:	57                   	push   %edi
80101a64:	56                   	push   %esi
80101a65:	53                   	push   %ebx
80101a66:	83 ec 1c             	sub    $0x1c,%esp
80101a69:	8b 45 08             	mov    0x8(%ebp),%eax
80101a6c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101a6f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a72:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101a77:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101a7a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a7d:	8b 75 10             	mov    0x10(%ebp),%esi
80101a80:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101a83:	0f 84 b7 00 00 00    	je     80101b40 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101a89:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a8c:	39 70 58             	cmp    %esi,0x58(%eax)
80101a8f:	0f 82 eb 00 00 00    	jb     80101b80 <writei+0x120>
80101a95:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101a98:	31 d2                	xor    %edx,%edx
80101a9a:	89 f8                	mov    %edi,%eax
80101a9c:	01 f0                	add    %esi,%eax
80101a9e:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101aa1:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101aa6:	0f 87 d4 00 00 00    	ja     80101b80 <writei+0x120>
80101aac:	85 d2                	test   %edx,%edx
80101aae:	0f 85 cc 00 00 00    	jne    80101b80 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101ab4:	85 ff                	test   %edi,%edi
80101ab6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101abd:	74 72                	je     80101b31 <writei+0xd1>
80101abf:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ac0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101ac3:	89 f2                	mov    %esi,%edx
80101ac5:	c1 ea 09             	shr    $0x9,%edx
80101ac8:	89 f8                	mov    %edi,%eax
80101aca:	e8 91 f8 ff ff       	call   80101360 <bmap>
80101acf:	83 ec 08             	sub    $0x8,%esp
80101ad2:	50                   	push   %eax
80101ad3:	ff 37                	pushl  (%edi)
80101ad5:	e8 f6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101ada:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101add:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ae0:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101ae2:	89 f0                	mov    %esi,%eax
80101ae4:	b9 00 02 00 00       	mov    $0x200,%ecx
80101ae9:	83 c4 0c             	add    $0xc,%esp
80101aec:	25 ff 01 00 00       	and    $0x1ff,%eax
80101af1:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101af3:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101af7:	39 d9                	cmp    %ebx,%ecx
80101af9:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101afc:	53                   	push   %ebx
80101afd:	ff 75 dc             	pushl  -0x24(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b00:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101b02:	50                   	push   %eax
80101b03:	e8 c8 3c 00 00       	call   801057d0 <memmove>
    log_write(bp);
80101b08:	89 3c 24             	mov    %edi,(%esp)
80101b0b:	e8 60 12 00 00       	call   80102d70 <log_write>
    brelse(bp);
80101b10:	89 3c 24             	mov    %edi,(%esp)
80101b13:	e8 c8 e6 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b18:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101b1b:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101b1e:	83 c4 10             	add    $0x10,%esp
80101b21:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101b24:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101b27:	77 97                	ja     80101ac0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101b29:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b2c:	3b 70 58             	cmp    0x58(%eax),%esi
80101b2f:	77 37                	ja     80101b68 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101b31:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101b34:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b37:	5b                   	pop    %ebx
80101b38:	5e                   	pop    %esi
80101b39:	5f                   	pop    %edi
80101b3a:	5d                   	pop    %ebp
80101b3b:	c3                   	ret    
80101b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101b40:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b44:	66 83 f8 09          	cmp    $0x9,%ax
80101b48:	77 36                	ja     80101b80 <writei+0x120>
80101b4a:	8b 04 c5 84 29 11 80 	mov    -0x7feed67c(,%eax,8),%eax
80101b51:	85 c0                	test   %eax,%eax
80101b53:	74 2b                	je     80101b80 <writei+0x120>
    return devsw[ip->major].write(ip, src, n);
80101b55:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101b58:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b5b:	5b                   	pop    %ebx
80101b5c:	5e                   	pop    %esi
80101b5d:	5f                   	pop    %edi
80101b5e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101b5f:	ff e0                	jmp    *%eax
80101b61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101b68:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101b6b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101b6e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101b71:	50                   	push   %eax
80101b72:	e8 59 fa ff ff       	call   801015d0 <iupdate>
80101b77:	83 c4 10             	add    $0x10,%esp
80101b7a:	eb b5                	jmp    80101b31 <writei+0xd1>
80101b7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80101b80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b85:	eb ad                	jmp    80101b34 <writei+0xd4>
80101b87:	89 f6                	mov    %esi,%esi
80101b89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101b90 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101b90:	55                   	push   %ebp
80101b91:	89 e5                	mov    %esp,%ebp
80101b93:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101b96:	6a 0e                	push   $0xe
80101b98:	ff 75 0c             	pushl  0xc(%ebp)
80101b9b:	ff 75 08             	pushl  0x8(%ebp)
80101b9e:	e8 9d 3c 00 00       	call   80105840 <strncmp>
}
80101ba3:	c9                   	leave  
80101ba4:	c3                   	ret    
80101ba5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101ba9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101bb0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101bb0:	55                   	push   %ebp
80101bb1:	89 e5                	mov    %esp,%ebp
80101bb3:	57                   	push   %edi
80101bb4:	56                   	push   %esi
80101bb5:	53                   	push   %ebx
80101bb6:	83 ec 1c             	sub    $0x1c,%esp
80101bb9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101bbc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101bc1:	0f 85 85 00 00 00    	jne    80101c4c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101bc7:	8b 53 58             	mov    0x58(%ebx),%edx
80101bca:	31 ff                	xor    %edi,%edi
80101bcc:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101bcf:	85 d2                	test   %edx,%edx
80101bd1:	74 3e                	je     80101c11 <dirlookup+0x61>
80101bd3:	90                   	nop
80101bd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101bd8:	6a 10                	push   $0x10
80101bda:	57                   	push   %edi
80101bdb:	56                   	push   %esi
80101bdc:	53                   	push   %ebx
80101bdd:	e8 7e fd ff ff       	call   80101960 <readi>
80101be2:	83 c4 10             	add    $0x10,%esp
80101be5:	83 f8 10             	cmp    $0x10,%eax
80101be8:	75 55                	jne    80101c3f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101bea:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101bef:	74 18                	je     80101c09 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101bf1:	8d 45 da             	lea    -0x26(%ebp),%eax
80101bf4:	83 ec 04             	sub    $0x4,%esp
80101bf7:	6a 0e                	push   $0xe
80101bf9:	50                   	push   %eax
80101bfa:	ff 75 0c             	pushl  0xc(%ebp)
80101bfd:	e8 3e 3c 00 00       	call   80105840 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101c02:	83 c4 10             	add    $0x10,%esp
80101c05:	85 c0                	test   %eax,%eax
80101c07:	74 17                	je     80101c20 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101c09:	83 c7 10             	add    $0x10,%edi
80101c0c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101c0f:	72 c7                	jb     80101bd8 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101c11:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101c14:	31 c0                	xor    %eax,%eax
}
80101c16:	5b                   	pop    %ebx
80101c17:	5e                   	pop    %esi
80101c18:	5f                   	pop    %edi
80101c19:	5d                   	pop    %ebp
80101c1a:	c3                   	ret    
80101c1b:	90                   	nop
80101c1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(poff)
80101c20:	8b 45 10             	mov    0x10(%ebp),%eax
80101c23:	85 c0                	test   %eax,%eax
80101c25:	74 05                	je     80101c2c <dirlookup+0x7c>
        *poff = off;
80101c27:	8b 45 10             	mov    0x10(%ebp),%eax
80101c2a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101c2c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101c30:	8b 03                	mov    (%ebx),%eax
80101c32:	e8 59 f6 ff ff       	call   80101290 <iget>
}
80101c37:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c3a:	5b                   	pop    %ebx
80101c3b:	5e                   	pop    %esi
80101c3c:	5f                   	pop    %edi
80101c3d:	5d                   	pop    %ebp
80101c3e:	c3                   	ret    
      panic("dirlookup read");
80101c3f:	83 ec 0c             	sub    $0xc,%esp
80101c42:	68 5a 84 10 80       	push   $0x8010845a
80101c47:	e8 44 e7 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101c4c:	83 ec 0c             	sub    $0xc,%esp
80101c4f:	68 48 84 10 80       	push   $0x80108448
80101c54:	e8 37 e7 ff ff       	call   80100390 <panic>
80101c59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101c60 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101c60:	55                   	push   %ebp
80101c61:	89 e5                	mov    %esp,%ebp
80101c63:	57                   	push   %edi
80101c64:	56                   	push   %esi
80101c65:	53                   	push   %ebx
80101c66:	89 cf                	mov    %ecx,%edi
80101c68:	89 c3                	mov    %eax,%ebx
80101c6a:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101c6d:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101c70:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(*path == '/')
80101c73:	0f 84 67 01 00 00    	je     80101de0 <namex+0x180>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101c79:	e8 22 1c 00 00       	call   801038a0 <myproc>
  acquire(&icache.lock);
80101c7e:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101c81:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101c84:	68 00 2a 11 80       	push   $0x80112a00
80101c89:	e8 82 39 00 00       	call   80105610 <acquire>
  ip->ref++;
80101c8e:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101c92:	c7 04 24 00 2a 11 80 	movl   $0x80112a00,(%esp)
80101c99:	e8 32 3a 00 00       	call   801056d0 <release>
80101c9e:	83 c4 10             	add    $0x10,%esp
80101ca1:	eb 08                	jmp    80101cab <namex+0x4b>
80101ca3:	90                   	nop
80101ca4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101ca8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101cab:	0f b6 03             	movzbl (%ebx),%eax
80101cae:	3c 2f                	cmp    $0x2f,%al
80101cb0:	74 f6                	je     80101ca8 <namex+0x48>
  if(*path == 0)
80101cb2:	84 c0                	test   %al,%al
80101cb4:	0f 84 ee 00 00 00    	je     80101da8 <namex+0x148>
  while(*path != '/' && *path != 0)
80101cba:	0f b6 03             	movzbl (%ebx),%eax
80101cbd:	3c 2f                	cmp    $0x2f,%al
80101cbf:	0f 84 b3 00 00 00    	je     80101d78 <namex+0x118>
80101cc5:	84 c0                	test   %al,%al
80101cc7:	89 da                	mov    %ebx,%edx
80101cc9:	75 09                	jne    80101cd4 <namex+0x74>
80101ccb:	e9 a8 00 00 00       	jmp    80101d78 <namex+0x118>
80101cd0:	84 c0                	test   %al,%al
80101cd2:	74 0a                	je     80101cde <namex+0x7e>
    path++;
80101cd4:	83 c2 01             	add    $0x1,%edx
  while(*path != '/' && *path != 0)
80101cd7:	0f b6 02             	movzbl (%edx),%eax
80101cda:	3c 2f                	cmp    $0x2f,%al
80101cdc:	75 f2                	jne    80101cd0 <namex+0x70>
80101cde:	89 d1                	mov    %edx,%ecx
80101ce0:	29 d9                	sub    %ebx,%ecx
  if(len >= DIRSIZ)
80101ce2:	83 f9 0d             	cmp    $0xd,%ecx
80101ce5:	0f 8e 91 00 00 00    	jle    80101d7c <namex+0x11c>
    memmove(name, s, DIRSIZ);
80101ceb:	83 ec 04             	sub    $0x4,%esp
80101cee:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101cf1:	6a 0e                	push   $0xe
80101cf3:	53                   	push   %ebx
80101cf4:	57                   	push   %edi
80101cf5:	e8 d6 3a 00 00       	call   801057d0 <memmove>
    path++;
80101cfa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    memmove(name, s, DIRSIZ);
80101cfd:	83 c4 10             	add    $0x10,%esp
    path++;
80101d00:	89 d3                	mov    %edx,%ebx
  while(*path == '/')
80101d02:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101d05:	75 11                	jne    80101d18 <namex+0xb8>
80101d07:	89 f6                	mov    %esi,%esi
80101d09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80101d10:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101d13:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101d16:	74 f8                	je     80101d10 <namex+0xb0>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101d18:	83 ec 0c             	sub    $0xc,%esp
80101d1b:	56                   	push   %esi
80101d1c:	e8 5f f9 ff ff       	call   80101680 <ilock>
    if(ip->type != T_DIR){
80101d21:	83 c4 10             	add    $0x10,%esp
80101d24:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101d29:	0f 85 91 00 00 00    	jne    80101dc0 <namex+0x160>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101d2f:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101d32:	85 d2                	test   %edx,%edx
80101d34:	74 09                	je     80101d3f <namex+0xdf>
80101d36:	80 3b 00             	cmpb   $0x0,(%ebx)
80101d39:	0f 84 b7 00 00 00    	je     80101df6 <namex+0x196>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101d3f:	83 ec 04             	sub    $0x4,%esp
80101d42:	6a 00                	push   $0x0
80101d44:	57                   	push   %edi
80101d45:	56                   	push   %esi
80101d46:	e8 65 fe ff ff       	call   80101bb0 <dirlookup>
80101d4b:	83 c4 10             	add    $0x10,%esp
80101d4e:	85 c0                	test   %eax,%eax
80101d50:	74 6e                	je     80101dc0 <namex+0x160>
  iunlock(ip);
80101d52:	83 ec 0c             	sub    $0xc,%esp
80101d55:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101d58:	56                   	push   %esi
80101d59:	e8 02 fa ff ff       	call   80101760 <iunlock>
  iput(ip);
80101d5e:	89 34 24             	mov    %esi,(%esp)
80101d61:	e8 4a fa ff ff       	call   801017b0 <iput>
80101d66:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101d69:	83 c4 10             	add    $0x10,%esp
80101d6c:	89 c6                	mov    %eax,%esi
80101d6e:	e9 38 ff ff ff       	jmp    80101cab <namex+0x4b>
80101d73:	90                   	nop
80101d74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(*path != '/' && *path != 0)
80101d78:	89 da                	mov    %ebx,%edx
80101d7a:	31 c9                	xor    %ecx,%ecx
    memmove(name, s, len);
80101d7c:	83 ec 04             	sub    $0x4,%esp
80101d7f:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101d82:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101d85:	51                   	push   %ecx
80101d86:	53                   	push   %ebx
80101d87:	57                   	push   %edi
80101d88:	e8 43 3a 00 00       	call   801057d0 <memmove>
    name[len] = 0;
80101d8d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101d90:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101d93:	83 c4 10             	add    $0x10,%esp
80101d96:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101d9a:	89 d3                	mov    %edx,%ebx
80101d9c:	e9 61 ff ff ff       	jmp    80101d02 <namex+0xa2>
80101da1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101da8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101dab:	85 c0                	test   %eax,%eax
80101dad:	75 5d                	jne    80101e0c <namex+0x1ac>
    iput(ip);
    return 0;
  }
  return ip;
}
80101daf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101db2:	89 f0                	mov    %esi,%eax
80101db4:	5b                   	pop    %ebx
80101db5:	5e                   	pop    %esi
80101db6:	5f                   	pop    %edi
80101db7:	5d                   	pop    %ebp
80101db8:	c3                   	ret    
80101db9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80101dc0:	83 ec 0c             	sub    $0xc,%esp
80101dc3:	56                   	push   %esi
80101dc4:	e8 97 f9 ff ff       	call   80101760 <iunlock>
  iput(ip);
80101dc9:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101dcc:	31 f6                	xor    %esi,%esi
  iput(ip);
80101dce:	e8 dd f9 ff ff       	call   801017b0 <iput>
      return 0;
80101dd3:	83 c4 10             	add    $0x10,%esp
}
80101dd6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101dd9:	89 f0                	mov    %esi,%eax
80101ddb:	5b                   	pop    %ebx
80101ddc:	5e                   	pop    %esi
80101ddd:	5f                   	pop    %edi
80101dde:	5d                   	pop    %ebp
80101ddf:	c3                   	ret    
    ip = iget(ROOTDEV, ROOTINO);
80101de0:	ba 01 00 00 00       	mov    $0x1,%edx
80101de5:	b8 01 00 00 00       	mov    $0x1,%eax
80101dea:	e8 a1 f4 ff ff       	call   80101290 <iget>
80101def:	89 c6                	mov    %eax,%esi
80101df1:	e9 b5 fe ff ff       	jmp    80101cab <namex+0x4b>
      iunlock(ip);
80101df6:	83 ec 0c             	sub    $0xc,%esp
80101df9:	56                   	push   %esi
80101dfa:	e8 61 f9 ff ff       	call   80101760 <iunlock>
      return ip;
80101dff:	83 c4 10             	add    $0x10,%esp
}
80101e02:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e05:	89 f0                	mov    %esi,%eax
80101e07:	5b                   	pop    %ebx
80101e08:	5e                   	pop    %esi
80101e09:	5f                   	pop    %edi
80101e0a:	5d                   	pop    %ebp
80101e0b:	c3                   	ret    
    iput(ip);
80101e0c:	83 ec 0c             	sub    $0xc,%esp
80101e0f:	56                   	push   %esi
    return 0;
80101e10:	31 f6                	xor    %esi,%esi
    iput(ip);
80101e12:	e8 99 f9 ff ff       	call   801017b0 <iput>
    return 0;
80101e17:	83 c4 10             	add    $0x10,%esp
80101e1a:	eb 93                	jmp    80101daf <namex+0x14f>
80101e1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101e20 <dirlink>:
{
80101e20:	55                   	push   %ebp
80101e21:	89 e5                	mov    %esp,%ebp
80101e23:	57                   	push   %edi
80101e24:	56                   	push   %esi
80101e25:	53                   	push   %ebx
80101e26:	83 ec 20             	sub    $0x20,%esp
80101e29:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101e2c:	6a 00                	push   $0x0
80101e2e:	ff 75 0c             	pushl  0xc(%ebp)
80101e31:	53                   	push   %ebx
80101e32:	e8 79 fd ff ff       	call   80101bb0 <dirlookup>
80101e37:	83 c4 10             	add    $0x10,%esp
80101e3a:	85 c0                	test   %eax,%eax
80101e3c:	75 67                	jne    80101ea5 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101e3e:	8b 7b 58             	mov    0x58(%ebx),%edi
80101e41:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e44:	85 ff                	test   %edi,%edi
80101e46:	74 29                	je     80101e71 <dirlink+0x51>
80101e48:	31 ff                	xor    %edi,%edi
80101e4a:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e4d:	eb 09                	jmp    80101e58 <dirlink+0x38>
80101e4f:	90                   	nop
80101e50:	83 c7 10             	add    $0x10,%edi
80101e53:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101e56:	73 19                	jae    80101e71 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e58:	6a 10                	push   $0x10
80101e5a:	57                   	push   %edi
80101e5b:	56                   	push   %esi
80101e5c:	53                   	push   %ebx
80101e5d:	e8 fe fa ff ff       	call   80101960 <readi>
80101e62:	83 c4 10             	add    $0x10,%esp
80101e65:	83 f8 10             	cmp    $0x10,%eax
80101e68:	75 4e                	jne    80101eb8 <dirlink+0x98>
    if(de.inum == 0)
80101e6a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101e6f:	75 df                	jne    80101e50 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80101e71:	8d 45 da             	lea    -0x26(%ebp),%eax
80101e74:	83 ec 04             	sub    $0x4,%esp
80101e77:	6a 0e                	push   $0xe
80101e79:	ff 75 0c             	pushl  0xc(%ebp)
80101e7c:	50                   	push   %eax
80101e7d:	e8 1e 3a 00 00       	call   801058a0 <strncpy>
  de.inum = inum;
80101e82:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e85:	6a 10                	push   $0x10
80101e87:	57                   	push   %edi
80101e88:	56                   	push   %esi
80101e89:	53                   	push   %ebx
  de.inum = inum;
80101e8a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e8e:	e8 cd fb ff ff       	call   80101a60 <writei>
80101e93:	83 c4 20             	add    $0x20,%esp
80101e96:	83 f8 10             	cmp    $0x10,%eax
80101e99:	75 2a                	jne    80101ec5 <dirlink+0xa5>
  return 0;
80101e9b:	31 c0                	xor    %eax,%eax
}
80101e9d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ea0:	5b                   	pop    %ebx
80101ea1:	5e                   	pop    %esi
80101ea2:	5f                   	pop    %edi
80101ea3:	5d                   	pop    %ebp
80101ea4:	c3                   	ret    
    iput(ip);
80101ea5:	83 ec 0c             	sub    $0xc,%esp
80101ea8:	50                   	push   %eax
80101ea9:	e8 02 f9 ff ff       	call   801017b0 <iput>
    return -1;
80101eae:	83 c4 10             	add    $0x10,%esp
80101eb1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101eb6:	eb e5                	jmp    80101e9d <dirlink+0x7d>
      panic("dirlink read");
80101eb8:	83 ec 0c             	sub    $0xc,%esp
80101ebb:	68 69 84 10 80       	push   $0x80108469
80101ec0:	e8 cb e4 ff ff       	call   80100390 <panic>
    panic("dirlink");
80101ec5:	83 ec 0c             	sub    $0xc,%esp
80101ec8:	68 0e 8e 10 80       	push   $0x80108e0e
80101ecd:	e8 be e4 ff ff       	call   80100390 <panic>
80101ed2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ed9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101ee0 <namei>:

struct inode*
namei(char *path)
{
80101ee0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101ee1:	31 d2                	xor    %edx,%edx
{
80101ee3:	89 e5                	mov    %esp,%ebp
80101ee5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80101ee8:	8b 45 08             	mov    0x8(%ebp),%eax
80101eeb:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101eee:	e8 6d fd ff ff       	call   80101c60 <namex>
}
80101ef3:	c9                   	leave  
80101ef4:	c3                   	ret    
80101ef5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101ef9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f00 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101f00:	55                   	push   %ebp
  return namex(path, 1, name);
80101f01:	ba 01 00 00 00       	mov    $0x1,%edx
{
80101f06:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101f08:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101f0b:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101f0e:	5d                   	pop    %ebp
  return namex(path, 1, name);
80101f0f:	e9 4c fd ff ff       	jmp    80101c60 <namex>
80101f14:	66 90                	xchg   %ax,%ax
80101f16:	66 90                	xchg   %ax,%ax
80101f18:	66 90                	xchg   %ax,%ax
80101f1a:	66 90                	xchg   %ax,%ax
80101f1c:	66 90                	xchg   %ax,%ax
80101f1e:	66 90                	xchg   %ax,%ax

80101f20 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101f20:	55                   	push   %ebp
80101f21:	89 e5                	mov    %esp,%ebp
80101f23:	57                   	push   %edi
80101f24:	56                   	push   %esi
80101f25:	53                   	push   %ebx
80101f26:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80101f29:	85 c0                	test   %eax,%eax
80101f2b:	0f 84 b4 00 00 00    	je     80101fe5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101f31:	8b 58 08             	mov    0x8(%eax),%ebx
80101f34:	89 c6                	mov    %eax,%esi
80101f36:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
80101f3c:	0f 87 96 00 00 00    	ja     80101fd8 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101f42:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80101f47:	89 f6                	mov    %esi,%esi
80101f49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80101f50:	89 ca                	mov    %ecx,%edx
80101f52:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101f53:	83 e0 c0             	and    $0xffffffc0,%eax
80101f56:	3c 40                	cmp    $0x40,%al
80101f58:	75 f6                	jne    80101f50 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101f5a:	31 ff                	xor    %edi,%edi
80101f5c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101f61:	89 f8                	mov    %edi,%eax
80101f63:	ee                   	out    %al,(%dx)
80101f64:	b8 01 00 00 00       	mov    $0x1,%eax
80101f69:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101f6e:	ee                   	out    %al,(%dx)
80101f6f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80101f74:	89 d8                	mov    %ebx,%eax
80101f76:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80101f77:	89 d8                	mov    %ebx,%eax
80101f79:	ba f4 01 00 00       	mov    $0x1f4,%edx
80101f7e:	c1 f8 08             	sar    $0x8,%eax
80101f81:	ee                   	out    %al,(%dx)
80101f82:	ba f5 01 00 00       	mov    $0x1f5,%edx
80101f87:	89 f8                	mov    %edi,%eax
80101f89:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80101f8a:	0f b6 46 04          	movzbl 0x4(%esi),%eax
80101f8e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101f93:	c1 e0 04             	shl    $0x4,%eax
80101f96:	83 e0 10             	and    $0x10,%eax
80101f99:	83 c8 e0             	or     $0xffffffe0,%eax
80101f9c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80101f9d:	f6 06 04             	testb  $0x4,(%esi)
80101fa0:	75 16                	jne    80101fb8 <idestart+0x98>
80101fa2:	b8 20 00 00 00       	mov    $0x20,%eax
80101fa7:	89 ca                	mov    %ecx,%edx
80101fa9:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101faa:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fad:	5b                   	pop    %ebx
80101fae:	5e                   	pop    %esi
80101faf:	5f                   	pop    %edi
80101fb0:	5d                   	pop    %ebp
80101fb1:	c3                   	ret    
80101fb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101fb8:	b8 30 00 00 00       	mov    $0x30,%eax
80101fbd:	89 ca                	mov    %ecx,%edx
80101fbf:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80101fc0:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80101fc5:	83 c6 5c             	add    $0x5c,%esi
80101fc8:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101fcd:	fc                   	cld    
80101fce:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80101fd0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fd3:	5b                   	pop    %ebx
80101fd4:	5e                   	pop    %esi
80101fd5:	5f                   	pop    %edi
80101fd6:	5d                   	pop    %ebp
80101fd7:	c3                   	ret    
    panic("incorrect blockno");
80101fd8:	83 ec 0c             	sub    $0xc,%esp
80101fdb:	68 d4 84 10 80       	push   $0x801084d4
80101fe0:	e8 ab e3 ff ff       	call   80100390 <panic>
    panic("idestart");
80101fe5:	83 ec 0c             	sub    $0xc,%esp
80101fe8:	68 cb 84 10 80       	push   $0x801084cb
80101fed:	e8 9e e3 ff ff       	call   80100390 <panic>
80101ff2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ff9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102000 <ideinit>:
{
80102000:	55                   	push   %ebp
80102001:	89 e5                	mov    %esp,%ebp
80102003:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102006:	68 e6 84 10 80       	push   $0x801084e6
8010200b:	68 a0 c5 10 80       	push   $0x8010c5a0
80102010:	e8 bb 34 00 00       	call   801054d0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102015:	58                   	pop    %eax
80102016:	a1 20 4d 11 80       	mov    0x80114d20,%eax
8010201b:	5a                   	pop    %edx
8010201c:	83 e8 01             	sub    $0x1,%eax
8010201f:	50                   	push   %eax
80102020:	6a 0e                	push   $0xe
80102022:	e8 a9 02 00 00       	call   801022d0 <ioapicenable>
80102027:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010202a:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010202f:	90                   	nop
80102030:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102031:	83 e0 c0             	and    $0xffffffc0,%eax
80102034:	3c 40                	cmp    $0x40,%al
80102036:	75 f8                	jne    80102030 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102038:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010203d:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102042:	ee                   	out    %al,(%dx)
80102043:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102048:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010204d:	eb 06                	jmp    80102055 <ideinit+0x55>
8010204f:	90                   	nop
  for(i=0; i<1000; i++){
80102050:	83 e9 01             	sub    $0x1,%ecx
80102053:	74 0f                	je     80102064 <ideinit+0x64>
80102055:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102056:	84 c0                	test   %al,%al
80102058:	74 f6                	je     80102050 <ideinit+0x50>
      havedisk1 = 1;
8010205a:	c7 05 80 c5 10 80 01 	movl   $0x1,0x8010c580
80102061:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102064:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102069:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010206e:	ee                   	out    %al,(%dx)
}
8010206f:	c9                   	leave  
80102070:	c3                   	ret    
80102071:	eb 0d                	jmp    80102080 <ideintr>
80102073:	90                   	nop
80102074:	90                   	nop
80102075:	90                   	nop
80102076:	90                   	nop
80102077:	90                   	nop
80102078:	90                   	nop
80102079:	90                   	nop
8010207a:	90                   	nop
8010207b:	90                   	nop
8010207c:	90                   	nop
8010207d:	90                   	nop
8010207e:	90                   	nop
8010207f:	90                   	nop

80102080 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102080:	55                   	push   %ebp
80102081:	89 e5                	mov    %esp,%ebp
80102083:	57                   	push   %edi
80102084:	56                   	push   %esi
80102085:	53                   	push   %ebx
80102086:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102089:	68 a0 c5 10 80       	push   $0x8010c5a0
8010208e:	e8 7d 35 00 00       	call   80105610 <acquire>

  if((b = idequeue) == 0){
80102093:	8b 1d 84 c5 10 80    	mov    0x8010c584,%ebx
80102099:	83 c4 10             	add    $0x10,%esp
8010209c:	85 db                	test   %ebx,%ebx
8010209e:	74 67                	je     80102107 <ideintr+0x87>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
801020a0:	8b 43 58             	mov    0x58(%ebx),%eax
801020a3:	a3 84 c5 10 80       	mov    %eax,0x8010c584

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801020a8:	8b 3b                	mov    (%ebx),%edi
801020aa:	f7 c7 04 00 00 00    	test   $0x4,%edi
801020b0:	75 31                	jne    801020e3 <ideintr+0x63>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020b2:	ba f7 01 00 00       	mov    $0x1f7,%edx
801020b7:	89 f6                	mov    %esi,%esi
801020b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801020c0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801020c1:	89 c6                	mov    %eax,%esi
801020c3:	83 e6 c0             	and    $0xffffffc0,%esi
801020c6:	89 f1                	mov    %esi,%ecx
801020c8:	80 f9 40             	cmp    $0x40,%cl
801020cb:	75 f3                	jne    801020c0 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801020cd:	a8 21                	test   $0x21,%al
801020cf:	75 12                	jne    801020e3 <ideintr+0x63>
    insl(0x1f0, b->data, BSIZE/4);
801020d1:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
801020d4:	b9 80 00 00 00       	mov    $0x80,%ecx
801020d9:	ba f0 01 00 00       	mov    $0x1f0,%edx
801020de:	fc                   	cld    
801020df:	f3 6d                	rep insl (%dx),%es:(%edi)
801020e1:	8b 3b                	mov    (%ebx),%edi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
801020e3:	83 e7 fb             	and    $0xfffffffb,%edi
  wakeup(b);
801020e6:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
801020e9:	89 f9                	mov    %edi,%ecx
801020eb:	83 c9 02             	or     $0x2,%ecx
801020ee:	89 0b                	mov    %ecx,(%ebx)
  wakeup(b);
801020f0:	53                   	push   %ebx
801020f1:	e8 ba 2e 00 00       	call   80104fb0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801020f6:	a1 84 c5 10 80       	mov    0x8010c584,%eax
801020fb:	83 c4 10             	add    $0x10,%esp
801020fe:	85 c0                	test   %eax,%eax
80102100:	74 05                	je     80102107 <ideintr+0x87>
    idestart(idequeue);
80102102:	e8 19 fe ff ff       	call   80101f20 <idestart>
    release(&idelock);
80102107:	83 ec 0c             	sub    $0xc,%esp
8010210a:	68 a0 c5 10 80       	push   $0x8010c5a0
8010210f:	e8 bc 35 00 00       	call   801056d0 <release>

  release(&idelock);
}
80102114:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102117:	5b                   	pop    %ebx
80102118:	5e                   	pop    %esi
80102119:	5f                   	pop    %edi
8010211a:	5d                   	pop    %ebp
8010211b:	c3                   	ret    
8010211c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102120 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102120:	55                   	push   %ebp
80102121:	89 e5                	mov    %esp,%ebp
80102123:	53                   	push   %ebx
80102124:	83 ec 10             	sub    $0x10,%esp
80102127:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010212a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010212d:	50                   	push   %eax
8010212e:	e8 4d 33 00 00       	call   80105480 <holdingsleep>
80102133:	83 c4 10             	add    $0x10,%esp
80102136:	85 c0                	test   %eax,%eax
80102138:	0f 84 c6 00 00 00    	je     80102204 <iderw+0xe4>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010213e:	8b 03                	mov    (%ebx),%eax
80102140:	83 e0 06             	and    $0x6,%eax
80102143:	83 f8 02             	cmp    $0x2,%eax
80102146:	0f 84 ab 00 00 00    	je     801021f7 <iderw+0xd7>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010214c:	8b 53 04             	mov    0x4(%ebx),%edx
8010214f:	85 d2                	test   %edx,%edx
80102151:	74 0d                	je     80102160 <iderw+0x40>
80102153:	a1 80 c5 10 80       	mov    0x8010c580,%eax
80102158:	85 c0                	test   %eax,%eax
8010215a:	0f 84 b1 00 00 00    	je     80102211 <iderw+0xf1>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102160:	83 ec 0c             	sub    $0xc,%esp
80102163:	68 a0 c5 10 80       	push   $0x8010c5a0
80102168:	e8 a3 34 00 00       	call   80105610 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010216d:	8b 15 84 c5 10 80    	mov    0x8010c584,%edx
80102173:	83 c4 10             	add    $0x10,%esp
  b->qnext = 0;
80102176:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010217d:	85 d2                	test   %edx,%edx
8010217f:	75 09                	jne    8010218a <iderw+0x6a>
80102181:	eb 6d                	jmp    801021f0 <iderw+0xd0>
80102183:	90                   	nop
80102184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102188:	89 c2                	mov    %eax,%edx
8010218a:	8b 42 58             	mov    0x58(%edx),%eax
8010218d:	85 c0                	test   %eax,%eax
8010218f:	75 f7                	jne    80102188 <iderw+0x68>
80102191:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102194:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102196:	39 1d 84 c5 10 80    	cmp    %ebx,0x8010c584
8010219c:	74 42                	je     801021e0 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010219e:	8b 03                	mov    (%ebx),%eax
801021a0:	83 e0 06             	and    $0x6,%eax
801021a3:	83 f8 02             	cmp    $0x2,%eax
801021a6:	74 23                	je     801021cb <iderw+0xab>
801021a8:	90                   	nop
801021a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
801021b0:	83 ec 08             	sub    $0x8,%esp
801021b3:	68 a0 c5 10 80       	push   $0x8010c5a0
801021b8:	53                   	push   %ebx
801021b9:	e8 d2 2a 00 00       	call   80104c90 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801021be:	8b 03                	mov    (%ebx),%eax
801021c0:	83 c4 10             	add    $0x10,%esp
801021c3:	83 e0 06             	and    $0x6,%eax
801021c6:	83 f8 02             	cmp    $0x2,%eax
801021c9:	75 e5                	jne    801021b0 <iderw+0x90>
  }


  release(&idelock);
801021cb:	c7 45 08 a0 c5 10 80 	movl   $0x8010c5a0,0x8(%ebp)
}
801021d2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801021d5:	c9                   	leave  
  release(&idelock);
801021d6:	e9 f5 34 00 00       	jmp    801056d0 <release>
801021db:	90                   	nop
801021dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    idestart(b);
801021e0:	89 d8                	mov    %ebx,%eax
801021e2:	e8 39 fd ff ff       	call   80101f20 <idestart>
801021e7:	eb b5                	jmp    8010219e <iderw+0x7e>
801021e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801021f0:	ba 84 c5 10 80       	mov    $0x8010c584,%edx
801021f5:	eb 9d                	jmp    80102194 <iderw+0x74>
    panic("iderw: nothing to do");
801021f7:	83 ec 0c             	sub    $0xc,%esp
801021fa:	68 00 85 10 80       	push   $0x80108500
801021ff:	e8 8c e1 ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102204:	83 ec 0c             	sub    $0xc,%esp
80102207:	68 ea 84 10 80       	push   $0x801084ea
8010220c:	e8 7f e1 ff ff       	call   80100390 <panic>
    panic("iderw: ide disk 1 not present");
80102211:	83 ec 0c             	sub    $0xc,%esp
80102214:	68 15 85 10 80       	push   $0x80108515
80102219:	e8 72 e1 ff ff       	call   80100390 <panic>
8010221e:	66 90                	xchg   %ax,%ax

80102220 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102220:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102221:	c7 05 54 46 11 80 00 	movl   $0xfec00000,0x80114654
80102228:	00 c0 fe 
{
8010222b:	89 e5                	mov    %esp,%ebp
8010222d:	56                   	push   %esi
8010222e:	53                   	push   %ebx
  ioapic->reg = reg;
8010222f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102236:	00 00 00 
  return ioapic->data;
80102239:	a1 54 46 11 80       	mov    0x80114654,%eax
8010223e:	8b 58 10             	mov    0x10(%eax),%ebx
  ioapic->reg = reg;
80102241:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  return ioapic->data;
80102247:	8b 0d 54 46 11 80    	mov    0x80114654,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010224d:	0f b6 15 80 47 11 80 	movzbl 0x80114780,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102254:	c1 eb 10             	shr    $0x10,%ebx
  return ioapic->data;
80102257:	8b 41 10             	mov    0x10(%ecx),%eax
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
8010225a:	0f b6 db             	movzbl %bl,%ebx
  id = ioapicread(REG_ID) >> 24;
8010225d:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102260:	39 c2                	cmp    %eax,%edx
80102262:	74 16                	je     8010227a <ioapicinit+0x5a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102264:	83 ec 0c             	sub    $0xc,%esp
80102267:	68 34 85 10 80       	push   $0x80108534
8010226c:	e8 ef e3 ff ff       	call   80100660 <cprintf>
80102271:	8b 0d 54 46 11 80    	mov    0x80114654,%ecx
80102277:	83 c4 10             	add    $0x10,%esp
8010227a:	83 c3 21             	add    $0x21,%ebx
{
8010227d:	ba 10 00 00 00       	mov    $0x10,%edx
80102282:	b8 20 00 00 00       	mov    $0x20,%eax
80102287:	89 f6                	mov    %esi,%esi
80102289:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ioapic->reg = reg;
80102290:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
80102292:	8b 0d 54 46 11 80    	mov    0x80114654,%ecx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102298:	89 c6                	mov    %eax,%esi
8010229a:	81 ce 00 00 01 00    	or     $0x10000,%esi
801022a0:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801022a3:	89 71 10             	mov    %esi,0x10(%ecx)
801022a6:	8d 72 01             	lea    0x1(%edx),%esi
801022a9:	83 c2 02             	add    $0x2,%edx
  for(i = 0; i <= maxintr; i++){
801022ac:	39 d8                	cmp    %ebx,%eax
  ioapic->reg = reg;
801022ae:	89 31                	mov    %esi,(%ecx)
  ioapic->data = data;
801022b0:	8b 0d 54 46 11 80    	mov    0x80114654,%ecx
801022b6:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
801022bd:	75 d1                	jne    80102290 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801022bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801022c2:	5b                   	pop    %ebx
801022c3:	5e                   	pop    %esi
801022c4:	5d                   	pop    %ebp
801022c5:	c3                   	ret    
801022c6:	8d 76 00             	lea    0x0(%esi),%esi
801022c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801022d0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801022d0:	55                   	push   %ebp
  ioapic->reg = reg;
801022d1:	8b 0d 54 46 11 80    	mov    0x80114654,%ecx
{
801022d7:	89 e5                	mov    %esp,%ebp
801022d9:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801022dc:	8d 50 20             	lea    0x20(%eax),%edx
801022df:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
801022e3:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801022e5:	8b 0d 54 46 11 80    	mov    0x80114654,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022eb:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801022ee:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022f1:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801022f4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801022f6:	a1 54 46 11 80       	mov    0x80114654,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022fb:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
801022fe:	89 50 10             	mov    %edx,0x10(%eax)
}
80102301:	5d                   	pop    %ebp
80102302:	c3                   	ret    
80102303:	66 90                	xchg   %ax,%ax
80102305:	66 90                	xchg   %ax,%ax
80102307:	66 90                	xchg   %ax,%ax
80102309:	66 90                	xchg   %ax,%ax
8010230b:	66 90                	xchg   %ax,%ax
8010230d:	66 90                	xchg   %ax,%ax
8010230f:	90                   	nop

80102310 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102310:	55                   	push   %ebp
80102311:	89 e5                	mov    %esp,%ebp
80102313:	53                   	push   %ebx
80102314:	83 ec 04             	sub    $0x4,%esp
80102317:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010231a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102320:	75 70                	jne    80102392 <kfree+0x82>
80102322:	81 fb c8 89 11 80    	cmp    $0x801189c8,%ebx
80102328:	72 68                	jb     80102392 <kfree+0x82>
8010232a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102330:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102335:	77 5b                	ja     80102392 <kfree+0x82>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102337:	83 ec 04             	sub    $0x4,%esp
8010233a:	68 00 10 00 00       	push   $0x1000
8010233f:	6a 01                	push   $0x1
80102341:	53                   	push   %ebx
80102342:	e8 d9 33 00 00       	call   80105720 <memset>

  if(kmem.use_lock)
80102347:	8b 15 94 46 11 80    	mov    0x80114694,%edx
8010234d:	83 c4 10             	add    $0x10,%esp
80102350:	85 d2                	test   %edx,%edx
80102352:	75 2c                	jne    80102380 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102354:	a1 98 46 11 80       	mov    0x80114698,%eax
80102359:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010235b:	a1 94 46 11 80       	mov    0x80114694,%eax
  kmem.freelist = r;
80102360:	89 1d 98 46 11 80    	mov    %ebx,0x80114698
  if(kmem.use_lock)
80102366:	85 c0                	test   %eax,%eax
80102368:	75 06                	jne    80102370 <kfree+0x60>
    release(&kmem.lock);
}
8010236a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010236d:	c9                   	leave  
8010236e:	c3                   	ret    
8010236f:	90                   	nop
    release(&kmem.lock);
80102370:	c7 45 08 60 46 11 80 	movl   $0x80114660,0x8(%ebp)
}
80102377:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010237a:	c9                   	leave  
    release(&kmem.lock);
8010237b:	e9 50 33 00 00       	jmp    801056d0 <release>
    acquire(&kmem.lock);
80102380:	83 ec 0c             	sub    $0xc,%esp
80102383:	68 60 46 11 80       	push   $0x80114660
80102388:	e8 83 32 00 00       	call   80105610 <acquire>
8010238d:	83 c4 10             	add    $0x10,%esp
80102390:	eb c2                	jmp    80102354 <kfree+0x44>
    panic("kfree");
80102392:	83 ec 0c             	sub    $0xc,%esp
80102395:	68 66 85 10 80       	push   $0x80108566
8010239a:	e8 f1 df ff ff       	call   80100390 <panic>
8010239f:	90                   	nop

801023a0 <freerange>:
{
801023a0:	55                   	push   %ebp
801023a1:	89 e5                	mov    %esp,%ebp
801023a3:	56                   	push   %esi
801023a4:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801023a5:	8b 45 08             	mov    0x8(%ebp),%eax
{
801023a8:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801023ab:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801023b1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023b7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801023bd:	39 de                	cmp    %ebx,%esi
801023bf:	72 23                	jb     801023e4 <freerange+0x44>
801023c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801023c8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801023ce:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023d1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801023d7:	50                   	push   %eax
801023d8:	e8 33 ff ff ff       	call   80102310 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023dd:	83 c4 10             	add    $0x10,%esp
801023e0:	39 f3                	cmp    %esi,%ebx
801023e2:	76 e4                	jbe    801023c8 <freerange+0x28>
}
801023e4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801023e7:	5b                   	pop    %ebx
801023e8:	5e                   	pop    %esi
801023e9:	5d                   	pop    %ebp
801023ea:	c3                   	ret    
801023eb:	90                   	nop
801023ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801023f0 <kinit1>:
{
801023f0:	55                   	push   %ebp
801023f1:	89 e5                	mov    %esp,%ebp
801023f3:	56                   	push   %esi
801023f4:	53                   	push   %ebx
801023f5:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801023f8:	83 ec 08             	sub    $0x8,%esp
801023fb:	68 6c 85 10 80       	push   $0x8010856c
80102400:	68 60 46 11 80       	push   $0x80114660
80102405:	e8 c6 30 00 00       	call   801054d0 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010240a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010240d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102410:	c7 05 94 46 11 80 00 	movl   $0x0,0x80114694
80102417:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010241a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102420:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102426:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010242c:	39 de                	cmp    %ebx,%esi
8010242e:	72 1c                	jb     8010244c <kinit1+0x5c>
    kfree(p);
80102430:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102436:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102439:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010243f:	50                   	push   %eax
80102440:	e8 cb fe ff ff       	call   80102310 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102445:	83 c4 10             	add    $0x10,%esp
80102448:	39 de                	cmp    %ebx,%esi
8010244a:	73 e4                	jae    80102430 <kinit1+0x40>
}
8010244c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010244f:	5b                   	pop    %ebx
80102450:	5e                   	pop    %esi
80102451:	5d                   	pop    %ebp
80102452:	c3                   	ret    
80102453:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102459:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102460 <kinit2>:
{
80102460:	55                   	push   %ebp
80102461:	89 e5                	mov    %esp,%ebp
80102463:	56                   	push   %esi
80102464:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102465:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102468:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010246b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102471:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102477:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010247d:	39 de                	cmp    %ebx,%esi
8010247f:	72 23                	jb     801024a4 <kinit2+0x44>
80102481:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102488:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010248e:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102491:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102497:	50                   	push   %eax
80102498:	e8 73 fe ff ff       	call   80102310 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010249d:	83 c4 10             	add    $0x10,%esp
801024a0:	39 de                	cmp    %ebx,%esi
801024a2:	73 e4                	jae    80102488 <kinit2+0x28>
  kmem.use_lock = 1;
801024a4:	c7 05 94 46 11 80 01 	movl   $0x1,0x80114694
801024ab:	00 00 00 
}
801024ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
801024b1:	5b                   	pop    %ebx
801024b2:	5e                   	pop    %esi
801024b3:	5d                   	pop    %ebp
801024b4:	c3                   	ret    
801024b5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801024b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801024c0 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
801024c0:	a1 94 46 11 80       	mov    0x80114694,%eax
801024c5:	85 c0                	test   %eax,%eax
801024c7:	75 1f                	jne    801024e8 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
801024c9:	a1 98 46 11 80       	mov    0x80114698,%eax
  if(r)
801024ce:	85 c0                	test   %eax,%eax
801024d0:	74 0e                	je     801024e0 <kalloc+0x20>
    kmem.freelist = r->next;
801024d2:	8b 10                	mov    (%eax),%edx
801024d4:	89 15 98 46 11 80    	mov    %edx,0x80114698
801024da:	c3                   	ret    
801024db:	90                   	nop
801024dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
801024e0:	f3 c3                	repz ret 
801024e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
801024e8:	55                   	push   %ebp
801024e9:	89 e5                	mov    %esp,%ebp
801024eb:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
801024ee:	68 60 46 11 80       	push   $0x80114660
801024f3:	e8 18 31 00 00       	call   80105610 <acquire>
  r = kmem.freelist;
801024f8:	a1 98 46 11 80       	mov    0x80114698,%eax
  if(r)
801024fd:	83 c4 10             	add    $0x10,%esp
80102500:	8b 15 94 46 11 80    	mov    0x80114694,%edx
80102506:	85 c0                	test   %eax,%eax
80102508:	74 08                	je     80102512 <kalloc+0x52>
    kmem.freelist = r->next;
8010250a:	8b 08                	mov    (%eax),%ecx
8010250c:	89 0d 98 46 11 80    	mov    %ecx,0x80114698
  if(kmem.use_lock)
80102512:	85 d2                	test   %edx,%edx
80102514:	74 16                	je     8010252c <kalloc+0x6c>
    release(&kmem.lock);
80102516:	83 ec 0c             	sub    $0xc,%esp
80102519:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010251c:	68 60 46 11 80       	push   $0x80114660
80102521:	e8 aa 31 00 00       	call   801056d0 <release>
  return (char*)r;
80102526:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102529:	83 c4 10             	add    $0x10,%esp
}
8010252c:	c9                   	leave  
8010252d:	c3                   	ret    
8010252e:	66 90                	xchg   %ax,%ax

80102530 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102530:	ba 64 00 00 00       	mov    $0x64,%edx
80102535:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102536:	a8 01                	test   $0x1,%al
80102538:	0f 84 c2 00 00 00    	je     80102600 <kbdgetc+0xd0>
8010253e:	ba 60 00 00 00       	mov    $0x60,%edx
80102543:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102544:	0f b6 d0             	movzbl %al,%edx
80102547:	8b 0d d4 c5 10 80    	mov    0x8010c5d4,%ecx

  if(data == 0xE0){
8010254d:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102553:	0f 84 7f 00 00 00    	je     801025d8 <kbdgetc+0xa8>
{
80102559:	55                   	push   %ebp
8010255a:	89 e5                	mov    %esp,%ebp
8010255c:	53                   	push   %ebx
8010255d:	89 cb                	mov    %ecx,%ebx
8010255f:	83 e3 40             	and    $0x40,%ebx
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102562:	84 c0                	test   %al,%al
80102564:	78 4a                	js     801025b0 <kbdgetc+0x80>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102566:	85 db                	test   %ebx,%ebx
80102568:	74 09                	je     80102573 <kbdgetc+0x43>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
8010256a:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
8010256d:	83 e1 bf             	and    $0xffffffbf,%ecx
    data |= 0x80;
80102570:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
80102573:	0f b6 82 a0 86 10 80 	movzbl -0x7fef7960(%edx),%eax
8010257a:	09 c1                	or     %eax,%ecx
  shift ^= togglecode[data];
8010257c:	0f b6 82 a0 85 10 80 	movzbl -0x7fef7a60(%edx),%eax
80102583:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102585:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102587:	89 0d d4 c5 10 80    	mov    %ecx,0x8010c5d4
  c = charcode[shift & (CTL | SHIFT)][data];
8010258d:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102590:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102593:	8b 04 85 80 85 10 80 	mov    -0x7fef7a80(,%eax,4),%eax
8010259a:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
8010259e:	74 31                	je     801025d1 <kbdgetc+0xa1>
    if('a' <= c && c <= 'z')
801025a0:	8d 50 9f             	lea    -0x61(%eax),%edx
801025a3:	83 fa 19             	cmp    $0x19,%edx
801025a6:	77 40                	ja     801025e8 <kbdgetc+0xb8>
      c += 'A' - 'a';
801025a8:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801025ab:	5b                   	pop    %ebx
801025ac:	5d                   	pop    %ebp
801025ad:	c3                   	ret    
801025ae:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
801025b0:	83 e0 7f             	and    $0x7f,%eax
801025b3:	85 db                	test   %ebx,%ebx
801025b5:	0f 44 d0             	cmove  %eax,%edx
    shift &= ~(shiftcode[data] | E0ESC);
801025b8:	0f b6 82 a0 86 10 80 	movzbl -0x7fef7960(%edx),%eax
801025bf:	83 c8 40             	or     $0x40,%eax
801025c2:	0f b6 c0             	movzbl %al,%eax
801025c5:	f7 d0                	not    %eax
801025c7:	21 c1                	and    %eax,%ecx
    return 0;
801025c9:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
801025cb:	89 0d d4 c5 10 80    	mov    %ecx,0x8010c5d4
}
801025d1:	5b                   	pop    %ebx
801025d2:	5d                   	pop    %ebp
801025d3:	c3                   	ret    
801025d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    shift |= E0ESC;
801025d8:	83 c9 40             	or     $0x40,%ecx
    return 0;
801025db:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
801025dd:	89 0d d4 c5 10 80    	mov    %ecx,0x8010c5d4
    return 0;
801025e3:	c3                   	ret    
801025e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
801025e8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801025eb:	8d 50 20             	lea    0x20(%eax),%edx
}
801025ee:	5b                   	pop    %ebx
      c += 'a' - 'A';
801025ef:	83 f9 1a             	cmp    $0x1a,%ecx
801025f2:	0f 42 c2             	cmovb  %edx,%eax
}
801025f5:	5d                   	pop    %ebp
801025f6:	c3                   	ret    
801025f7:	89 f6                	mov    %esi,%esi
801025f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80102600:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102605:	c3                   	ret    
80102606:	8d 76 00             	lea    0x0(%esi),%esi
80102609:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102610 <kbdintr>:

void
kbdintr(void)
{
80102610:	55                   	push   %ebp
80102611:	89 e5                	mov    %esp,%ebp
80102613:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102616:	68 30 25 10 80       	push   $0x80102530
8010261b:	e8 f0 e1 ff ff       	call   80100810 <consoleintr>
}
80102620:	83 c4 10             	add    $0x10,%esp
80102623:	c9                   	leave  
80102624:	c3                   	ret    
80102625:	66 90                	xchg   %ax,%ax
80102627:	66 90                	xchg   %ax,%ax
80102629:	66 90                	xchg   %ax,%ax
8010262b:	66 90                	xchg   %ax,%ax
8010262d:	66 90                	xchg   %ax,%ax
8010262f:	90                   	nop

80102630 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102630:	a1 9c 46 11 80       	mov    0x8011469c,%eax
{
80102635:	55                   	push   %ebp
80102636:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102638:	85 c0                	test   %eax,%eax
8010263a:	0f 84 c8 00 00 00    	je     80102708 <lapicinit+0xd8>
  lapic[index] = value;
80102640:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102647:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010264a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010264d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102654:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102657:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010265a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102661:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102664:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102667:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010266e:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102671:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102674:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
8010267b:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010267e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102681:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102688:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010268b:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010268e:	8b 50 30             	mov    0x30(%eax),%edx
80102691:	c1 ea 10             	shr    $0x10,%edx
80102694:	80 fa 03             	cmp    $0x3,%dl
80102697:	77 77                	ja     80102710 <lapicinit+0xe0>
  lapic[index] = value;
80102699:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
801026a0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026a3:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026a6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801026ad:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026b0:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026b3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801026ba:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026bd:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026c0:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801026c7:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026ca:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026cd:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
801026d4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026d7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026da:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801026e1:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
801026e4:	8b 50 20             	mov    0x20(%eax),%edx
801026e7:	89 f6                	mov    %esi,%esi
801026e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
801026f0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
801026f6:	80 e6 10             	and    $0x10,%dh
801026f9:	75 f5                	jne    801026f0 <lapicinit+0xc0>
  lapic[index] = value;
801026fb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102702:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102705:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102708:	5d                   	pop    %ebp
80102709:	c3                   	ret    
8010270a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  lapic[index] = value;
80102710:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102717:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010271a:	8b 50 20             	mov    0x20(%eax),%edx
8010271d:	e9 77 ff ff ff       	jmp    80102699 <lapicinit+0x69>
80102722:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102729:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102730 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102730:	8b 15 9c 46 11 80    	mov    0x8011469c,%edx
{
80102736:	55                   	push   %ebp
80102737:	31 c0                	xor    %eax,%eax
80102739:	89 e5                	mov    %esp,%ebp
  if (!lapic)
8010273b:	85 d2                	test   %edx,%edx
8010273d:	74 06                	je     80102745 <lapicid+0x15>
    return 0;
  return lapic[ID] >> 24;
8010273f:	8b 42 20             	mov    0x20(%edx),%eax
80102742:	c1 e8 18             	shr    $0x18,%eax
}
80102745:	5d                   	pop    %ebp
80102746:	c3                   	ret    
80102747:	89 f6                	mov    %esi,%esi
80102749:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102750 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102750:	a1 9c 46 11 80       	mov    0x8011469c,%eax
{
80102755:	55                   	push   %ebp
80102756:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102758:	85 c0                	test   %eax,%eax
8010275a:	74 0d                	je     80102769 <lapiceoi+0x19>
  lapic[index] = value;
8010275c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102763:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102766:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102769:	5d                   	pop    %ebp
8010276a:	c3                   	ret    
8010276b:	90                   	nop
8010276c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102770 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102770:	55                   	push   %ebp
80102771:	89 e5                	mov    %esp,%ebp
}
80102773:	5d                   	pop    %ebp
80102774:	c3                   	ret    
80102775:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102780 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102780:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102781:	b8 0f 00 00 00       	mov    $0xf,%eax
80102786:	ba 70 00 00 00       	mov    $0x70,%edx
8010278b:	89 e5                	mov    %esp,%ebp
8010278d:	53                   	push   %ebx
8010278e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102791:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102794:	ee                   	out    %al,(%dx)
80102795:	b8 0a 00 00 00       	mov    $0xa,%eax
8010279a:	ba 71 00 00 00       	mov    $0x71,%edx
8010279f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
801027a0:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
801027a2:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
801027a5:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
801027ab:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
801027ad:	c1 e9 0c             	shr    $0xc,%ecx
  wrv[1] = addr >> 4;
801027b0:	c1 e8 04             	shr    $0x4,%eax
  lapicw(ICRHI, apicid<<24);
801027b3:	89 da                	mov    %ebx,%edx
    lapicw(ICRLO, STARTUP | (addr>>12));
801027b5:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
801027b8:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
801027be:	a1 9c 46 11 80       	mov    0x8011469c,%eax
801027c3:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027c9:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801027cc:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
801027d3:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027d6:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801027d9:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
801027e0:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027e3:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801027e6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027ec:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801027ef:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027f5:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801027f8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027fe:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102801:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102807:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
8010280a:	5b                   	pop    %ebx
8010280b:	5d                   	pop    %ebp
8010280c:	c3                   	ret    
8010280d:	8d 76 00             	lea    0x0(%esi),%esi

80102810 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102810:	55                   	push   %ebp
80102811:	b8 0b 00 00 00       	mov    $0xb,%eax
80102816:	ba 70 00 00 00       	mov    $0x70,%edx
8010281b:	89 e5                	mov    %esp,%ebp
8010281d:	57                   	push   %edi
8010281e:	56                   	push   %esi
8010281f:	53                   	push   %ebx
80102820:	83 ec 4c             	sub    $0x4c,%esp
80102823:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102824:	ba 71 00 00 00       	mov    $0x71,%edx
80102829:	ec                   	in     (%dx),%al
8010282a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010282d:	bb 70 00 00 00       	mov    $0x70,%ebx
80102832:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102835:	8d 76 00             	lea    0x0(%esi),%esi
80102838:	31 c0                	xor    %eax,%eax
8010283a:	89 da                	mov    %ebx,%edx
8010283c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010283d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102842:	89 ca                	mov    %ecx,%edx
80102844:	ec                   	in     (%dx),%al
80102845:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102848:	89 da                	mov    %ebx,%edx
8010284a:	b8 02 00 00 00       	mov    $0x2,%eax
8010284f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102850:	89 ca                	mov    %ecx,%edx
80102852:	ec                   	in     (%dx),%al
80102853:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102856:	89 da                	mov    %ebx,%edx
80102858:	b8 04 00 00 00       	mov    $0x4,%eax
8010285d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010285e:	89 ca                	mov    %ecx,%edx
80102860:	ec                   	in     (%dx),%al
80102861:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102864:	89 da                	mov    %ebx,%edx
80102866:	b8 07 00 00 00       	mov    $0x7,%eax
8010286b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010286c:	89 ca                	mov    %ecx,%edx
8010286e:	ec                   	in     (%dx),%al
8010286f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102872:	89 da                	mov    %ebx,%edx
80102874:	b8 08 00 00 00       	mov    $0x8,%eax
80102879:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010287a:	89 ca                	mov    %ecx,%edx
8010287c:	ec                   	in     (%dx),%al
8010287d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010287f:	89 da                	mov    %ebx,%edx
80102881:	b8 09 00 00 00       	mov    $0x9,%eax
80102886:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102887:	89 ca                	mov    %ecx,%edx
80102889:	ec                   	in     (%dx),%al
8010288a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010288c:	89 da                	mov    %ebx,%edx
8010288e:	b8 0a 00 00 00       	mov    $0xa,%eax
80102893:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102894:	89 ca                	mov    %ecx,%edx
80102896:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102897:	84 c0                	test   %al,%al
80102899:	78 9d                	js     80102838 <cmostime+0x28>
  return inb(CMOS_RETURN);
8010289b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
8010289f:	89 fa                	mov    %edi,%edx
801028a1:	0f b6 fa             	movzbl %dl,%edi
801028a4:	89 f2                	mov    %esi,%edx
801028a6:	0f b6 f2             	movzbl %dl,%esi
801028a9:	89 7d c8             	mov    %edi,-0x38(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028ac:	89 da                	mov    %ebx,%edx
801028ae:	89 75 cc             	mov    %esi,-0x34(%ebp)
801028b1:	89 45 b8             	mov    %eax,-0x48(%ebp)
801028b4:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
801028b8:	89 45 bc             	mov    %eax,-0x44(%ebp)
801028bb:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
801028bf:	89 45 c0             	mov    %eax,-0x40(%ebp)
801028c2:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
801028c6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
801028c9:	31 c0                	xor    %eax,%eax
801028cb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028cc:	89 ca                	mov    %ecx,%edx
801028ce:	ec                   	in     (%dx),%al
801028cf:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028d2:	89 da                	mov    %ebx,%edx
801028d4:	89 45 d0             	mov    %eax,-0x30(%ebp)
801028d7:	b8 02 00 00 00       	mov    $0x2,%eax
801028dc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028dd:	89 ca                	mov    %ecx,%edx
801028df:	ec                   	in     (%dx),%al
801028e0:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028e3:	89 da                	mov    %ebx,%edx
801028e5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
801028e8:	b8 04 00 00 00       	mov    $0x4,%eax
801028ed:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028ee:	89 ca                	mov    %ecx,%edx
801028f0:	ec                   	in     (%dx),%al
801028f1:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028f4:	89 da                	mov    %ebx,%edx
801028f6:	89 45 d8             	mov    %eax,-0x28(%ebp)
801028f9:	b8 07 00 00 00       	mov    $0x7,%eax
801028fe:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028ff:	89 ca                	mov    %ecx,%edx
80102901:	ec                   	in     (%dx),%al
80102902:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102905:	89 da                	mov    %ebx,%edx
80102907:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010290a:	b8 08 00 00 00       	mov    $0x8,%eax
8010290f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102910:	89 ca                	mov    %ecx,%edx
80102912:	ec                   	in     (%dx),%al
80102913:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102916:	89 da                	mov    %ebx,%edx
80102918:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010291b:	b8 09 00 00 00       	mov    $0x9,%eax
80102920:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102921:	89 ca                	mov    %ecx,%edx
80102923:	ec                   	in     (%dx),%al
80102924:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102927:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
8010292a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
8010292d:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102930:	6a 18                	push   $0x18
80102932:	50                   	push   %eax
80102933:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102936:	50                   	push   %eax
80102937:	e8 34 2e 00 00       	call   80105770 <memcmp>
8010293c:	83 c4 10             	add    $0x10,%esp
8010293f:	85 c0                	test   %eax,%eax
80102941:	0f 85 f1 fe ff ff    	jne    80102838 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102947:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
8010294b:	75 78                	jne    801029c5 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
8010294d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102950:	89 c2                	mov    %eax,%edx
80102952:	83 e0 0f             	and    $0xf,%eax
80102955:	c1 ea 04             	shr    $0x4,%edx
80102958:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010295b:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010295e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102961:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102964:	89 c2                	mov    %eax,%edx
80102966:	83 e0 0f             	and    $0xf,%eax
80102969:	c1 ea 04             	shr    $0x4,%edx
8010296c:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010296f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102972:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102975:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102978:	89 c2                	mov    %eax,%edx
8010297a:	83 e0 0f             	and    $0xf,%eax
8010297d:	c1 ea 04             	shr    $0x4,%edx
80102980:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102983:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102986:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102989:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010298c:	89 c2                	mov    %eax,%edx
8010298e:	83 e0 0f             	and    $0xf,%eax
80102991:	c1 ea 04             	shr    $0x4,%edx
80102994:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102997:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010299a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
8010299d:	8b 45 c8             	mov    -0x38(%ebp),%eax
801029a0:	89 c2                	mov    %eax,%edx
801029a2:	83 e0 0f             	and    $0xf,%eax
801029a5:	c1 ea 04             	shr    $0x4,%edx
801029a8:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029ab:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029ae:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
801029b1:	8b 45 cc             	mov    -0x34(%ebp),%eax
801029b4:	89 c2                	mov    %eax,%edx
801029b6:	83 e0 0f             	and    $0xf,%eax
801029b9:	c1 ea 04             	shr    $0x4,%edx
801029bc:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029bf:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029c2:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
801029c5:	8b 75 08             	mov    0x8(%ebp),%esi
801029c8:	8b 45 b8             	mov    -0x48(%ebp),%eax
801029cb:	89 06                	mov    %eax,(%esi)
801029cd:	8b 45 bc             	mov    -0x44(%ebp),%eax
801029d0:	89 46 04             	mov    %eax,0x4(%esi)
801029d3:	8b 45 c0             	mov    -0x40(%ebp),%eax
801029d6:	89 46 08             	mov    %eax,0x8(%esi)
801029d9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801029dc:	89 46 0c             	mov    %eax,0xc(%esi)
801029df:	8b 45 c8             	mov    -0x38(%ebp),%eax
801029e2:	89 46 10             	mov    %eax,0x10(%esi)
801029e5:	8b 45 cc             	mov    -0x34(%ebp),%eax
801029e8:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
801029eb:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
801029f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801029f5:	5b                   	pop    %ebx
801029f6:	5e                   	pop    %esi
801029f7:	5f                   	pop    %edi
801029f8:	5d                   	pop    %ebp
801029f9:	c3                   	ret    
801029fa:	66 90                	xchg   %ax,%ax
801029fc:	66 90                	xchg   %ax,%ax
801029fe:	66 90                	xchg   %ax,%ax

80102a00 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102a00:	8b 0d e8 46 11 80    	mov    0x801146e8,%ecx
80102a06:	85 c9                	test   %ecx,%ecx
80102a08:	0f 8e 8a 00 00 00    	jle    80102a98 <install_trans+0x98>
{
80102a0e:	55                   	push   %ebp
80102a0f:	89 e5                	mov    %esp,%ebp
80102a11:	57                   	push   %edi
80102a12:	56                   	push   %esi
80102a13:	53                   	push   %ebx
  for (tail = 0; tail < log.lh.n; tail++) {
80102a14:	31 db                	xor    %ebx,%ebx
{
80102a16:	83 ec 0c             	sub    $0xc,%esp
80102a19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102a20:	a1 d4 46 11 80       	mov    0x801146d4,%eax
80102a25:	83 ec 08             	sub    $0x8,%esp
80102a28:	01 d8                	add    %ebx,%eax
80102a2a:	83 c0 01             	add    $0x1,%eax
80102a2d:	50                   	push   %eax
80102a2e:	ff 35 e4 46 11 80    	pushl  0x801146e4
80102a34:	e8 97 d6 ff ff       	call   801000d0 <bread>
80102a39:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a3b:	58                   	pop    %eax
80102a3c:	5a                   	pop    %edx
80102a3d:	ff 34 9d ec 46 11 80 	pushl  -0x7feeb914(,%ebx,4)
80102a44:	ff 35 e4 46 11 80    	pushl  0x801146e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102a4a:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a4d:	e8 7e d6 ff ff       	call   801000d0 <bread>
80102a52:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102a54:	8d 47 5c             	lea    0x5c(%edi),%eax
80102a57:	83 c4 0c             	add    $0xc,%esp
80102a5a:	68 00 02 00 00       	push   $0x200
80102a5f:	50                   	push   %eax
80102a60:	8d 46 5c             	lea    0x5c(%esi),%eax
80102a63:	50                   	push   %eax
80102a64:	e8 67 2d 00 00       	call   801057d0 <memmove>
    bwrite(dbuf);  // write dst to disk
80102a69:	89 34 24             	mov    %esi,(%esp)
80102a6c:	e8 2f d7 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102a71:	89 3c 24             	mov    %edi,(%esp)
80102a74:	e8 67 d7 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102a79:	89 34 24             	mov    %esi,(%esp)
80102a7c:	e8 5f d7 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102a81:	83 c4 10             	add    $0x10,%esp
80102a84:	39 1d e8 46 11 80    	cmp    %ebx,0x801146e8
80102a8a:	7f 94                	jg     80102a20 <install_trans+0x20>
  }
}
80102a8c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102a8f:	5b                   	pop    %ebx
80102a90:	5e                   	pop    %esi
80102a91:	5f                   	pop    %edi
80102a92:	5d                   	pop    %ebp
80102a93:	c3                   	ret    
80102a94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102a98:	f3 c3                	repz ret 
80102a9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102aa0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102aa0:	55                   	push   %ebp
80102aa1:	89 e5                	mov    %esp,%ebp
80102aa3:	56                   	push   %esi
80102aa4:	53                   	push   %ebx
  struct buf *buf = bread(log.dev, log.start);
80102aa5:	83 ec 08             	sub    $0x8,%esp
80102aa8:	ff 35 d4 46 11 80    	pushl  0x801146d4
80102aae:	ff 35 e4 46 11 80    	pushl  0x801146e4
80102ab4:	e8 17 d6 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102ab9:	8b 1d e8 46 11 80    	mov    0x801146e8,%ebx
  for (i = 0; i < log.lh.n; i++) {
80102abf:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102ac2:	89 c6                	mov    %eax,%esi
  for (i = 0; i < log.lh.n; i++) {
80102ac4:	85 db                	test   %ebx,%ebx
  hb->n = log.lh.n;
80102ac6:	89 58 5c             	mov    %ebx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102ac9:	7e 16                	jle    80102ae1 <write_head+0x41>
80102acb:	c1 e3 02             	shl    $0x2,%ebx
80102ace:	31 d2                	xor    %edx,%edx
    hb->block[i] = log.lh.block[i];
80102ad0:	8b 8a ec 46 11 80    	mov    -0x7feeb914(%edx),%ecx
80102ad6:	89 4c 16 60          	mov    %ecx,0x60(%esi,%edx,1)
80102ada:	83 c2 04             	add    $0x4,%edx
  for (i = 0; i < log.lh.n; i++) {
80102add:	39 da                	cmp    %ebx,%edx
80102adf:	75 ef                	jne    80102ad0 <write_head+0x30>
  }
  bwrite(buf);
80102ae1:	83 ec 0c             	sub    $0xc,%esp
80102ae4:	56                   	push   %esi
80102ae5:	e8 b6 d6 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102aea:	89 34 24             	mov    %esi,(%esp)
80102aed:	e8 ee d6 ff ff       	call   801001e0 <brelse>
}
80102af2:	83 c4 10             	add    $0x10,%esp
80102af5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102af8:	5b                   	pop    %ebx
80102af9:	5e                   	pop    %esi
80102afa:	5d                   	pop    %ebp
80102afb:	c3                   	ret    
80102afc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102b00 <initlog>:
{
80102b00:	55                   	push   %ebp
80102b01:	89 e5                	mov    %esp,%ebp
80102b03:	53                   	push   %ebx
80102b04:	83 ec 2c             	sub    $0x2c,%esp
80102b07:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102b0a:	68 a0 87 10 80       	push   $0x801087a0
80102b0f:	68 a0 46 11 80       	push   $0x801146a0
80102b14:	e8 b7 29 00 00       	call   801054d0 <initlock>
  readsb(dev, &sb);
80102b19:	58                   	pop    %eax
80102b1a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102b1d:	5a                   	pop    %edx
80102b1e:	50                   	push   %eax
80102b1f:	53                   	push   %ebx
80102b20:	e8 1b e9 ff ff       	call   80101440 <readsb>
  log.size = sb.nlog;
80102b25:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102b28:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102b2b:	59                   	pop    %ecx
  log.dev = dev;
80102b2c:	89 1d e4 46 11 80    	mov    %ebx,0x801146e4
  log.size = sb.nlog;
80102b32:	89 15 d8 46 11 80    	mov    %edx,0x801146d8
  log.start = sb.logstart;
80102b38:	a3 d4 46 11 80       	mov    %eax,0x801146d4
  struct buf *buf = bread(log.dev, log.start);
80102b3d:	5a                   	pop    %edx
80102b3e:	50                   	push   %eax
80102b3f:	53                   	push   %ebx
80102b40:	e8 8b d5 ff ff       	call   801000d0 <bread>
  log.lh.n = lh->n;
80102b45:	8b 58 5c             	mov    0x5c(%eax),%ebx
  for (i = 0; i < log.lh.n; i++) {
80102b48:	83 c4 10             	add    $0x10,%esp
80102b4b:	85 db                	test   %ebx,%ebx
  log.lh.n = lh->n;
80102b4d:	89 1d e8 46 11 80    	mov    %ebx,0x801146e8
  for (i = 0; i < log.lh.n; i++) {
80102b53:	7e 1c                	jle    80102b71 <initlog+0x71>
80102b55:	c1 e3 02             	shl    $0x2,%ebx
80102b58:	31 d2                	xor    %edx,%edx
80102b5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    log.lh.block[i] = lh->block[i];
80102b60:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102b64:	83 c2 04             	add    $0x4,%edx
80102b67:	89 8a e8 46 11 80    	mov    %ecx,-0x7feeb918(%edx)
  for (i = 0; i < log.lh.n; i++) {
80102b6d:	39 d3                	cmp    %edx,%ebx
80102b6f:	75 ef                	jne    80102b60 <initlog+0x60>
  brelse(buf);
80102b71:	83 ec 0c             	sub    $0xc,%esp
80102b74:	50                   	push   %eax
80102b75:	e8 66 d6 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102b7a:	e8 81 fe ff ff       	call   80102a00 <install_trans>
  log.lh.n = 0;
80102b7f:	c7 05 e8 46 11 80 00 	movl   $0x0,0x801146e8
80102b86:	00 00 00 
  write_head(); // clear the log
80102b89:	e8 12 ff ff ff       	call   80102aa0 <write_head>
}
80102b8e:	83 c4 10             	add    $0x10,%esp
80102b91:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102b94:	c9                   	leave  
80102b95:	c3                   	ret    
80102b96:	8d 76 00             	lea    0x0(%esi),%esi
80102b99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102ba0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102ba0:	55                   	push   %ebp
80102ba1:	89 e5                	mov    %esp,%ebp
80102ba3:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102ba6:	68 a0 46 11 80       	push   $0x801146a0
80102bab:	e8 60 2a 00 00       	call   80105610 <acquire>
80102bb0:	83 c4 10             	add    $0x10,%esp
80102bb3:	eb 18                	jmp    80102bcd <begin_op+0x2d>
80102bb5:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102bb8:	83 ec 08             	sub    $0x8,%esp
80102bbb:	68 a0 46 11 80       	push   $0x801146a0
80102bc0:	68 a0 46 11 80       	push   $0x801146a0
80102bc5:	e8 c6 20 00 00       	call   80104c90 <sleep>
80102bca:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102bcd:	a1 e0 46 11 80       	mov    0x801146e0,%eax
80102bd2:	85 c0                	test   %eax,%eax
80102bd4:	75 e2                	jne    80102bb8 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102bd6:	a1 dc 46 11 80       	mov    0x801146dc,%eax
80102bdb:	8b 15 e8 46 11 80    	mov    0x801146e8,%edx
80102be1:	83 c0 01             	add    $0x1,%eax
80102be4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102be7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102bea:	83 fa 1e             	cmp    $0x1e,%edx
80102bed:	7f c9                	jg     80102bb8 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102bef:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102bf2:	a3 dc 46 11 80       	mov    %eax,0x801146dc
      release(&log.lock);
80102bf7:	68 a0 46 11 80       	push   $0x801146a0
80102bfc:	e8 cf 2a 00 00       	call   801056d0 <release>
      break;
    }
  }
}
80102c01:	83 c4 10             	add    $0x10,%esp
80102c04:	c9                   	leave  
80102c05:	c3                   	ret    
80102c06:	8d 76 00             	lea    0x0(%esi),%esi
80102c09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102c10 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102c10:	55                   	push   %ebp
80102c11:	89 e5                	mov    %esp,%ebp
80102c13:	57                   	push   %edi
80102c14:	56                   	push   %esi
80102c15:	53                   	push   %ebx
80102c16:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102c19:	68 a0 46 11 80       	push   $0x801146a0
80102c1e:	e8 ed 29 00 00       	call   80105610 <acquire>
  log.outstanding -= 1;
80102c23:	a1 dc 46 11 80       	mov    0x801146dc,%eax
  if(log.committing)
80102c28:	8b 35 e0 46 11 80    	mov    0x801146e0,%esi
80102c2e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102c31:	8d 58 ff             	lea    -0x1(%eax),%ebx
  if(log.committing)
80102c34:	85 f6                	test   %esi,%esi
  log.outstanding -= 1;
80102c36:	89 1d dc 46 11 80    	mov    %ebx,0x801146dc
  if(log.committing)
80102c3c:	0f 85 1a 01 00 00    	jne    80102d5c <end_op+0x14c>
    panic("log.committing");
  if(log.outstanding == 0){
80102c42:	85 db                	test   %ebx,%ebx
80102c44:	0f 85 ee 00 00 00    	jne    80102d38 <end_op+0x128>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102c4a:	83 ec 0c             	sub    $0xc,%esp
    log.committing = 1;
80102c4d:	c7 05 e0 46 11 80 01 	movl   $0x1,0x801146e0
80102c54:	00 00 00 
  release(&log.lock);
80102c57:	68 a0 46 11 80       	push   $0x801146a0
80102c5c:	e8 6f 2a 00 00       	call   801056d0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102c61:	8b 0d e8 46 11 80    	mov    0x801146e8,%ecx
80102c67:	83 c4 10             	add    $0x10,%esp
80102c6a:	85 c9                	test   %ecx,%ecx
80102c6c:	0f 8e 85 00 00 00    	jle    80102cf7 <end_op+0xe7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102c72:	a1 d4 46 11 80       	mov    0x801146d4,%eax
80102c77:	83 ec 08             	sub    $0x8,%esp
80102c7a:	01 d8                	add    %ebx,%eax
80102c7c:	83 c0 01             	add    $0x1,%eax
80102c7f:	50                   	push   %eax
80102c80:	ff 35 e4 46 11 80    	pushl  0x801146e4
80102c86:	e8 45 d4 ff ff       	call   801000d0 <bread>
80102c8b:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c8d:	58                   	pop    %eax
80102c8e:	5a                   	pop    %edx
80102c8f:	ff 34 9d ec 46 11 80 	pushl  -0x7feeb914(,%ebx,4)
80102c96:	ff 35 e4 46 11 80    	pushl  0x801146e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102c9c:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c9f:	e8 2c d4 ff ff       	call   801000d0 <bread>
80102ca4:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102ca6:	8d 40 5c             	lea    0x5c(%eax),%eax
80102ca9:	83 c4 0c             	add    $0xc,%esp
80102cac:	68 00 02 00 00       	push   $0x200
80102cb1:	50                   	push   %eax
80102cb2:	8d 46 5c             	lea    0x5c(%esi),%eax
80102cb5:	50                   	push   %eax
80102cb6:	e8 15 2b 00 00       	call   801057d0 <memmove>
    bwrite(to);  // write the log
80102cbb:	89 34 24             	mov    %esi,(%esp)
80102cbe:	e8 dd d4 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102cc3:	89 3c 24             	mov    %edi,(%esp)
80102cc6:	e8 15 d5 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102ccb:	89 34 24             	mov    %esi,(%esp)
80102cce:	e8 0d d5 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102cd3:	83 c4 10             	add    $0x10,%esp
80102cd6:	3b 1d e8 46 11 80    	cmp    0x801146e8,%ebx
80102cdc:	7c 94                	jl     80102c72 <end_op+0x62>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102cde:	e8 bd fd ff ff       	call   80102aa0 <write_head>
    install_trans(); // Now install writes to home locations
80102ce3:	e8 18 fd ff ff       	call   80102a00 <install_trans>
    log.lh.n = 0;
80102ce8:	c7 05 e8 46 11 80 00 	movl   $0x0,0x801146e8
80102cef:	00 00 00 
    write_head();    // Erase the transaction from the log
80102cf2:	e8 a9 fd ff ff       	call   80102aa0 <write_head>
    acquire(&log.lock);
80102cf7:	83 ec 0c             	sub    $0xc,%esp
80102cfa:	68 a0 46 11 80       	push   $0x801146a0
80102cff:	e8 0c 29 00 00       	call   80105610 <acquire>
    wakeup(&log);
80102d04:	c7 04 24 a0 46 11 80 	movl   $0x801146a0,(%esp)
    log.committing = 0;
80102d0b:	c7 05 e0 46 11 80 00 	movl   $0x0,0x801146e0
80102d12:	00 00 00 
    wakeup(&log);
80102d15:	e8 96 22 00 00       	call   80104fb0 <wakeup>
    release(&log.lock);
80102d1a:	c7 04 24 a0 46 11 80 	movl   $0x801146a0,(%esp)
80102d21:	e8 aa 29 00 00       	call   801056d0 <release>
80102d26:	83 c4 10             	add    $0x10,%esp
}
80102d29:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d2c:	5b                   	pop    %ebx
80102d2d:	5e                   	pop    %esi
80102d2e:	5f                   	pop    %edi
80102d2f:	5d                   	pop    %ebp
80102d30:	c3                   	ret    
80102d31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&log);
80102d38:	83 ec 0c             	sub    $0xc,%esp
80102d3b:	68 a0 46 11 80       	push   $0x801146a0
80102d40:	e8 6b 22 00 00       	call   80104fb0 <wakeup>
  release(&log.lock);
80102d45:	c7 04 24 a0 46 11 80 	movl   $0x801146a0,(%esp)
80102d4c:	e8 7f 29 00 00       	call   801056d0 <release>
80102d51:	83 c4 10             	add    $0x10,%esp
}
80102d54:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d57:	5b                   	pop    %ebx
80102d58:	5e                   	pop    %esi
80102d59:	5f                   	pop    %edi
80102d5a:	5d                   	pop    %ebp
80102d5b:	c3                   	ret    
    panic("log.committing");
80102d5c:	83 ec 0c             	sub    $0xc,%esp
80102d5f:	68 a4 87 10 80       	push   $0x801087a4
80102d64:	e8 27 d6 ff ff       	call   80100390 <panic>
80102d69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102d70 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102d70:	55                   	push   %ebp
80102d71:	89 e5                	mov    %esp,%ebp
80102d73:	53                   	push   %ebx
80102d74:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102d77:	8b 15 e8 46 11 80    	mov    0x801146e8,%edx
{
80102d7d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102d80:	83 fa 1d             	cmp    $0x1d,%edx
80102d83:	0f 8f 9d 00 00 00    	jg     80102e26 <log_write+0xb6>
80102d89:	a1 d8 46 11 80       	mov    0x801146d8,%eax
80102d8e:	83 e8 01             	sub    $0x1,%eax
80102d91:	39 c2                	cmp    %eax,%edx
80102d93:	0f 8d 8d 00 00 00    	jge    80102e26 <log_write+0xb6>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102d99:	a1 dc 46 11 80       	mov    0x801146dc,%eax
80102d9e:	85 c0                	test   %eax,%eax
80102da0:	0f 8e 8d 00 00 00    	jle    80102e33 <log_write+0xc3>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102da6:	83 ec 0c             	sub    $0xc,%esp
80102da9:	68 a0 46 11 80       	push   $0x801146a0
80102dae:	e8 5d 28 00 00       	call   80105610 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102db3:	8b 0d e8 46 11 80    	mov    0x801146e8,%ecx
80102db9:	83 c4 10             	add    $0x10,%esp
80102dbc:	83 f9 00             	cmp    $0x0,%ecx
80102dbf:	7e 57                	jle    80102e18 <log_write+0xa8>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102dc1:	8b 53 08             	mov    0x8(%ebx),%edx
  for (i = 0; i < log.lh.n; i++) {
80102dc4:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102dc6:	3b 15 ec 46 11 80    	cmp    0x801146ec,%edx
80102dcc:	75 0b                	jne    80102dd9 <log_write+0x69>
80102dce:	eb 38                	jmp    80102e08 <log_write+0x98>
80102dd0:	39 14 85 ec 46 11 80 	cmp    %edx,-0x7feeb914(,%eax,4)
80102dd7:	74 2f                	je     80102e08 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80102dd9:	83 c0 01             	add    $0x1,%eax
80102ddc:	39 c1                	cmp    %eax,%ecx
80102dde:	75 f0                	jne    80102dd0 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80102de0:	89 14 85 ec 46 11 80 	mov    %edx,-0x7feeb914(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
80102de7:	83 c0 01             	add    $0x1,%eax
80102dea:	a3 e8 46 11 80       	mov    %eax,0x801146e8
  b->flags |= B_DIRTY; // prevent eviction
80102def:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102df2:	c7 45 08 a0 46 11 80 	movl   $0x801146a0,0x8(%ebp)
}
80102df9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102dfc:	c9                   	leave  
  release(&log.lock);
80102dfd:	e9 ce 28 00 00       	jmp    801056d0 <release>
80102e02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80102e08:	89 14 85 ec 46 11 80 	mov    %edx,-0x7feeb914(,%eax,4)
80102e0f:	eb de                	jmp    80102def <log_write+0x7f>
80102e11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e18:	8b 43 08             	mov    0x8(%ebx),%eax
80102e1b:	a3 ec 46 11 80       	mov    %eax,0x801146ec
  if (i == log.lh.n)
80102e20:	75 cd                	jne    80102def <log_write+0x7f>
80102e22:	31 c0                	xor    %eax,%eax
80102e24:	eb c1                	jmp    80102de7 <log_write+0x77>
    panic("too big a transaction");
80102e26:	83 ec 0c             	sub    $0xc,%esp
80102e29:	68 b3 87 10 80       	push   $0x801087b3
80102e2e:	e8 5d d5 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80102e33:	83 ec 0c             	sub    $0xc,%esp
80102e36:	68 c9 87 10 80       	push   $0x801087c9
80102e3b:	e8 50 d5 ff ff       	call   80100390 <panic>

80102e40 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102e40:	55                   	push   %ebp
80102e41:	89 e5                	mov    %esp,%ebp
80102e43:	53                   	push   %ebx
80102e44:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102e47:	e8 34 0a 00 00       	call   80103880 <cpuid>
80102e4c:	89 c3                	mov    %eax,%ebx
80102e4e:	e8 2d 0a 00 00       	call   80103880 <cpuid>
80102e53:	83 ec 04             	sub    $0x4,%esp
80102e56:	53                   	push   %ebx
80102e57:	50                   	push   %eax
80102e58:	68 e4 87 10 80       	push   $0x801087e4
80102e5d:	e8 fe d7 ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
80102e62:	e8 39 3c 00 00       	call   80106aa0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102e67:	e8 94 09 00 00       	call   80103800 <mycpu>
80102e6c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102e6e:	b8 01 00 00 00       	mov    $0x1,%eax
80102e73:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102e7a:	e8 21 15 00 00       	call   801043a0 <scheduler>
80102e7f:	90                   	nop

80102e80 <mpenter>:
{
80102e80:	55                   	push   %ebp
80102e81:	89 e5                	mov    %esp,%ebp
80102e83:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102e86:	e8 85 4d 00 00       	call   80107c10 <switchkvm>
  seginit();
80102e8b:	e8 f0 4c 00 00       	call   80107b80 <seginit>
  lapicinit();
80102e90:	e8 9b f7 ff ff       	call   80102630 <lapicinit>
  mpmain();
80102e95:	e8 a6 ff ff ff       	call   80102e40 <mpmain>
80102e9a:	66 90                	xchg   %ax,%ax
80102e9c:	66 90                	xchg   %ax,%ax
80102e9e:	66 90                	xchg   %ax,%ax

80102ea0 <main>:
{
80102ea0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80102ea4:	83 e4 f0             	and    $0xfffffff0,%esp
80102ea7:	ff 71 fc             	pushl  -0x4(%ecx)
80102eaa:	55                   	push   %ebp
80102eab:	89 e5                	mov    %esp,%ebp
80102ead:	53                   	push   %ebx
80102eae:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102eaf:	83 ec 08             	sub    $0x8,%esp
80102eb2:	68 00 00 40 80       	push   $0x80400000
80102eb7:	68 c8 89 11 80       	push   $0x801189c8
80102ebc:	e8 2f f5 ff ff       	call   801023f0 <kinit1>
  kvmalloc();      // kernel page table
80102ec1:	e8 1a 52 00 00       	call   801080e0 <kvmalloc>
  mpinit();        // detect other processors
80102ec6:	e8 75 01 00 00       	call   80103040 <mpinit>
  lapicinit();     // interrupt controller
80102ecb:	e8 60 f7 ff ff       	call   80102630 <lapicinit>
  seginit();       // segment descriptors
80102ed0:	e8 ab 4c 00 00       	call   80107b80 <seginit>
  picinit();       // disable pic
80102ed5:	e8 46 03 00 00       	call   80103220 <picinit>
  ioapicinit();    // another interrupt controller
80102eda:	e8 41 f3 ff ff       	call   80102220 <ioapicinit>
  consoleinit();   // console hardware
80102edf:	e8 dc da ff ff       	call   801009c0 <consoleinit>
  uartinit();      // serial port
80102ee4:	e8 67 3f 00 00       	call   80106e50 <uartinit>
  pinit();         // process table
80102ee9:	e8 f2 08 00 00       	call   801037e0 <pinit>
  tvinit();        // trap vectors
80102eee:	e8 2d 3b 00 00       	call   80106a20 <tvinit>
  binit();         // buffer cache
80102ef3:	e8 48 d1 ff ff       	call   80100040 <binit>
  fileinit();      // file table
80102ef8:	e8 63 de ff ff       	call   80100d60 <fileinit>
  ideinit();       // disk 
80102efd:	e8 fe f0 ff ff       	call   80102000 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102f02:	83 c4 0c             	add    $0xc,%esp
80102f05:	68 8a 00 00 00       	push   $0x8a
80102f0a:	68 ac c4 10 80       	push   $0x8010c4ac
80102f0f:	68 00 70 00 80       	push   $0x80007000
80102f14:	e8 b7 28 00 00       	call   801057d0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102f19:	69 05 20 4d 11 80 b0 	imul   $0xb0,0x80114d20,%eax
80102f20:	00 00 00 
80102f23:	83 c4 10             	add    $0x10,%esp
80102f26:	05 a0 47 11 80       	add    $0x801147a0,%eax
80102f2b:	3d a0 47 11 80       	cmp    $0x801147a0,%eax
80102f30:	76 71                	jbe    80102fa3 <main+0x103>
80102f32:	bb a0 47 11 80       	mov    $0x801147a0,%ebx
80102f37:	89 f6                	mov    %esi,%esi
80102f39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c == mycpu())  // We've started already.
80102f40:	e8 bb 08 00 00       	call   80103800 <mycpu>
80102f45:	39 d8                	cmp    %ebx,%eax
80102f47:	74 41                	je     80102f8a <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102f49:	e8 72 f5 ff ff       	call   801024c0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
80102f4e:	05 00 10 00 00       	add    $0x1000,%eax
    *(void(**)(void))(code-8) = mpenter;
80102f53:	c7 05 f8 6f 00 80 80 	movl   $0x80102e80,0x80006ff8
80102f5a:	2e 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102f5d:	c7 05 f4 6f 00 80 00 	movl   $0x10b000,0x80006ff4
80102f64:	b0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
80102f67:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

    lapicstartap(c->apicid, V2P(code));
80102f6c:	0f b6 03             	movzbl (%ebx),%eax
80102f6f:	83 ec 08             	sub    $0x8,%esp
80102f72:	68 00 70 00 00       	push   $0x7000
80102f77:	50                   	push   %eax
80102f78:	e8 03 f8 ff ff       	call   80102780 <lapicstartap>
80102f7d:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102f80:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80102f86:	85 c0                	test   %eax,%eax
80102f88:	74 f6                	je     80102f80 <main+0xe0>
  for(c = cpus; c < cpus+ncpu; c++){
80102f8a:	69 05 20 4d 11 80 b0 	imul   $0xb0,0x80114d20,%eax
80102f91:	00 00 00 
80102f94:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80102f9a:	05 a0 47 11 80       	add    $0x801147a0,%eax
80102f9f:	39 c3                	cmp    %eax,%ebx
80102fa1:	72 9d                	jb     80102f40 <main+0xa0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102fa3:	83 ec 08             	sub    $0x8,%esp
80102fa6:	68 00 00 00 8e       	push   $0x8e000000
80102fab:	68 00 00 40 80       	push   $0x80400000
80102fb0:	e8 ab f4 ff ff       	call   80102460 <kinit2>
  userinit();      // first user process
80102fb5:	e8 d6 0d 00 00       	call   80103d90 <userinit>
  mpmain();        // finish this processor's setup
80102fba:	e8 81 fe ff ff       	call   80102e40 <mpmain>
80102fbf:	90                   	nop

80102fc0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102fc0:	55                   	push   %ebp
80102fc1:	89 e5                	mov    %esp,%ebp
80102fc3:	57                   	push   %edi
80102fc4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80102fc5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
80102fcb:	53                   	push   %ebx
  e = addr+len;
80102fcc:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
80102fcf:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80102fd2:	39 de                	cmp    %ebx,%esi
80102fd4:	72 10                	jb     80102fe6 <mpsearch1+0x26>
80102fd6:	eb 50                	jmp    80103028 <mpsearch1+0x68>
80102fd8:	90                   	nop
80102fd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102fe0:	39 fb                	cmp    %edi,%ebx
80102fe2:	89 fe                	mov    %edi,%esi
80102fe4:	76 42                	jbe    80103028 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102fe6:	83 ec 04             	sub    $0x4,%esp
80102fe9:	8d 7e 10             	lea    0x10(%esi),%edi
80102fec:	6a 04                	push   $0x4
80102fee:	68 f8 87 10 80       	push   $0x801087f8
80102ff3:	56                   	push   %esi
80102ff4:	e8 77 27 00 00       	call   80105770 <memcmp>
80102ff9:	83 c4 10             	add    $0x10,%esp
80102ffc:	85 c0                	test   %eax,%eax
80102ffe:	75 e0                	jne    80102fe0 <mpsearch1+0x20>
80103000:	89 f1                	mov    %esi,%ecx
80103002:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103008:	0f b6 11             	movzbl (%ecx),%edx
8010300b:	83 c1 01             	add    $0x1,%ecx
8010300e:	01 d0                	add    %edx,%eax
  for(i=0; i<len; i++)
80103010:	39 f9                	cmp    %edi,%ecx
80103012:	75 f4                	jne    80103008 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103014:	84 c0                	test   %al,%al
80103016:	75 c8                	jne    80102fe0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103018:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010301b:	89 f0                	mov    %esi,%eax
8010301d:	5b                   	pop    %ebx
8010301e:	5e                   	pop    %esi
8010301f:	5f                   	pop    %edi
80103020:	5d                   	pop    %ebp
80103021:	c3                   	ret    
80103022:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103028:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010302b:	31 f6                	xor    %esi,%esi
}
8010302d:	89 f0                	mov    %esi,%eax
8010302f:	5b                   	pop    %ebx
80103030:	5e                   	pop    %esi
80103031:	5f                   	pop    %edi
80103032:	5d                   	pop    %ebp
80103033:	c3                   	ret    
80103034:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010303a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103040 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103040:	55                   	push   %ebp
80103041:	89 e5                	mov    %esp,%ebp
80103043:	57                   	push   %edi
80103044:	56                   	push   %esi
80103045:	53                   	push   %ebx
80103046:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103049:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103050:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103057:	c1 e0 08             	shl    $0x8,%eax
8010305a:	09 d0                	or     %edx,%eax
8010305c:	c1 e0 04             	shl    $0x4,%eax
8010305f:	85 c0                	test   %eax,%eax
80103061:	75 1b                	jne    8010307e <mpinit+0x3e>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103063:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010306a:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103071:	c1 e0 08             	shl    $0x8,%eax
80103074:	09 d0                	or     %edx,%eax
80103076:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103079:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010307e:	ba 00 04 00 00       	mov    $0x400,%edx
80103083:	e8 38 ff ff ff       	call   80102fc0 <mpsearch1>
80103088:	85 c0                	test   %eax,%eax
8010308a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010308d:	0f 84 3d 01 00 00    	je     801031d0 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103093:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103096:	8b 58 04             	mov    0x4(%eax),%ebx
80103099:	85 db                	test   %ebx,%ebx
8010309b:	0f 84 4f 01 00 00    	je     801031f0 <mpinit+0x1b0>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801030a1:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
801030a7:	83 ec 04             	sub    $0x4,%esp
801030aa:	6a 04                	push   $0x4
801030ac:	68 15 88 10 80       	push   $0x80108815
801030b1:	56                   	push   %esi
801030b2:	e8 b9 26 00 00       	call   80105770 <memcmp>
801030b7:	83 c4 10             	add    $0x10,%esp
801030ba:	85 c0                	test   %eax,%eax
801030bc:	0f 85 2e 01 00 00    	jne    801031f0 <mpinit+0x1b0>
  if(conf->version != 1 && conf->version != 4)
801030c2:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
801030c9:	3c 01                	cmp    $0x1,%al
801030cb:	0f 95 c2             	setne  %dl
801030ce:	3c 04                	cmp    $0x4,%al
801030d0:	0f 95 c0             	setne  %al
801030d3:	20 c2                	and    %al,%dl
801030d5:	0f 85 15 01 00 00    	jne    801031f0 <mpinit+0x1b0>
  if(sum((uchar*)conf, conf->length) != 0)
801030db:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
  for(i=0; i<len; i++)
801030e2:	66 85 ff             	test   %di,%di
801030e5:	74 1a                	je     80103101 <mpinit+0xc1>
801030e7:	89 f0                	mov    %esi,%eax
801030e9:	01 f7                	add    %esi,%edi
  sum = 0;
801030eb:	31 d2                	xor    %edx,%edx
801030ed:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801030f0:	0f b6 08             	movzbl (%eax),%ecx
801030f3:	83 c0 01             	add    $0x1,%eax
801030f6:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801030f8:	39 c7                	cmp    %eax,%edi
801030fa:	75 f4                	jne    801030f0 <mpinit+0xb0>
801030fc:	84 d2                	test   %dl,%dl
801030fe:	0f 95 c2             	setne  %dl
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103101:	85 f6                	test   %esi,%esi
80103103:	0f 84 e7 00 00 00    	je     801031f0 <mpinit+0x1b0>
80103109:	84 d2                	test   %dl,%dl
8010310b:	0f 85 df 00 00 00    	jne    801031f0 <mpinit+0x1b0>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103111:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
80103117:	a3 9c 46 11 80       	mov    %eax,0x8011469c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010311c:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
80103123:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  ismp = 1;
80103129:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010312e:	01 d6                	add    %edx,%esi
80103130:	39 c6                	cmp    %eax,%esi
80103132:	76 23                	jbe    80103157 <mpinit+0x117>
    switch(*p){
80103134:	0f b6 10             	movzbl (%eax),%edx
80103137:	80 fa 04             	cmp    $0x4,%dl
8010313a:	0f 87 ca 00 00 00    	ja     8010320a <mpinit+0x1ca>
80103140:	ff 24 95 3c 88 10 80 	jmp    *-0x7fef77c4(,%edx,4)
80103147:	89 f6                	mov    %esi,%esi
80103149:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103150:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103153:	39 c6                	cmp    %eax,%esi
80103155:	77 dd                	ja     80103134 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103157:	85 db                	test   %ebx,%ebx
80103159:	0f 84 9e 00 00 00    	je     801031fd <mpinit+0x1bd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010315f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103162:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
80103166:	74 15                	je     8010317d <mpinit+0x13d>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103168:	b8 70 00 00 00       	mov    $0x70,%eax
8010316d:	ba 22 00 00 00       	mov    $0x22,%edx
80103172:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103173:	ba 23 00 00 00       	mov    $0x23,%edx
80103178:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103179:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010317c:	ee                   	out    %al,(%dx)
  }
}
8010317d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103180:	5b                   	pop    %ebx
80103181:	5e                   	pop    %esi
80103182:	5f                   	pop    %edi
80103183:	5d                   	pop    %ebp
80103184:	c3                   	ret    
80103185:	8d 76 00             	lea    0x0(%esi),%esi
      if(ncpu < NCPU) {
80103188:	8b 0d 20 4d 11 80    	mov    0x80114d20,%ecx
8010318e:	83 f9 07             	cmp    $0x7,%ecx
80103191:	7f 19                	jg     801031ac <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103193:	0f b6 50 01          	movzbl 0x1(%eax),%edx
80103197:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
8010319d:	83 c1 01             	add    $0x1,%ecx
801031a0:	89 0d 20 4d 11 80    	mov    %ecx,0x80114d20
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801031a6:	88 97 a0 47 11 80    	mov    %dl,-0x7feeb860(%edi)
      p += sizeof(struct mpproc);
801031ac:	83 c0 14             	add    $0x14,%eax
      continue;
801031af:	e9 7c ff ff ff       	jmp    80103130 <mpinit+0xf0>
801031b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
801031b8:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
801031bc:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
801031bf:	88 15 80 47 11 80    	mov    %dl,0x80114780
      continue;
801031c5:	e9 66 ff ff ff       	jmp    80103130 <mpinit+0xf0>
801031ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return mpsearch1(0xF0000, 0x10000);
801031d0:	ba 00 00 01 00       	mov    $0x10000,%edx
801031d5:	b8 00 00 0f 00       	mov    $0xf0000,%eax
801031da:	e8 e1 fd ff ff       	call   80102fc0 <mpsearch1>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801031df:	85 c0                	test   %eax,%eax
  return mpsearch1(0xF0000, 0x10000);
801031e1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801031e4:	0f 85 a9 fe ff ff    	jne    80103093 <mpinit+0x53>
801031ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
801031f0:	83 ec 0c             	sub    $0xc,%esp
801031f3:	68 fd 87 10 80       	push   $0x801087fd
801031f8:	e8 93 d1 ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
801031fd:	83 ec 0c             	sub    $0xc,%esp
80103200:	68 1c 88 10 80       	push   $0x8010881c
80103205:	e8 86 d1 ff ff       	call   80100390 <panic>
      ismp = 0;
8010320a:	31 db                	xor    %ebx,%ebx
8010320c:	e9 26 ff ff ff       	jmp    80103137 <mpinit+0xf7>
80103211:	66 90                	xchg   %ax,%ax
80103213:	66 90                	xchg   %ax,%ax
80103215:	66 90                	xchg   %ax,%ax
80103217:	66 90                	xchg   %ax,%ax
80103219:	66 90                	xchg   %ax,%ax
8010321b:	66 90                	xchg   %ax,%ax
8010321d:	66 90                	xchg   %ax,%ax
8010321f:	90                   	nop

80103220 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103220:	55                   	push   %ebp
80103221:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103226:	ba 21 00 00 00       	mov    $0x21,%edx
8010322b:	89 e5                	mov    %esp,%ebp
8010322d:	ee                   	out    %al,(%dx)
8010322e:	ba a1 00 00 00       	mov    $0xa1,%edx
80103233:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103234:	5d                   	pop    %ebp
80103235:	c3                   	ret    
80103236:	66 90                	xchg   %ax,%ax
80103238:	66 90                	xchg   %ax,%ax
8010323a:	66 90                	xchg   %ax,%ax
8010323c:	66 90                	xchg   %ax,%ax
8010323e:	66 90                	xchg   %ax,%ax

80103240 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103240:	55                   	push   %ebp
80103241:	89 e5                	mov    %esp,%ebp
80103243:	57                   	push   %edi
80103244:	56                   	push   %esi
80103245:	53                   	push   %ebx
80103246:	83 ec 0c             	sub    $0xc,%esp
80103249:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010324c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010324f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103255:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010325b:	e8 20 db ff ff       	call   80100d80 <filealloc>
80103260:	85 c0                	test   %eax,%eax
80103262:	89 03                	mov    %eax,(%ebx)
80103264:	74 22                	je     80103288 <pipealloc+0x48>
80103266:	e8 15 db ff ff       	call   80100d80 <filealloc>
8010326b:	85 c0                	test   %eax,%eax
8010326d:	89 06                	mov    %eax,(%esi)
8010326f:	74 3f                	je     801032b0 <pipealloc+0x70>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103271:	e8 4a f2 ff ff       	call   801024c0 <kalloc>
80103276:	85 c0                	test   %eax,%eax
80103278:	89 c7                	mov    %eax,%edi
8010327a:	75 54                	jne    801032d0 <pipealloc+0x90>

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
8010327c:	8b 03                	mov    (%ebx),%eax
8010327e:	85 c0                	test   %eax,%eax
80103280:	75 34                	jne    801032b6 <pipealloc+0x76>
80103282:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    fileclose(*f0);
  if(*f1)
80103288:	8b 06                	mov    (%esi),%eax
8010328a:	85 c0                	test   %eax,%eax
8010328c:	74 0c                	je     8010329a <pipealloc+0x5a>
    fileclose(*f1);
8010328e:	83 ec 0c             	sub    $0xc,%esp
80103291:	50                   	push   %eax
80103292:	e8 a9 db ff ff       	call   80100e40 <fileclose>
80103297:	83 c4 10             	add    $0x10,%esp
  return -1;
}
8010329a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010329d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801032a2:	5b                   	pop    %ebx
801032a3:	5e                   	pop    %esi
801032a4:	5f                   	pop    %edi
801032a5:	5d                   	pop    %ebp
801032a6:	c3                   	ret    
801032a7:	89 f6                	mov    %esi,%esi
801032a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(*f0)
801032b0:	8b 03                	mov    (%ebx),%eax
801032b2:	85 c0                	test   %eax,%eax
801032b4:	74 e4                	je     8010329a <pipealloc+0x5a>
    fileclose(*f0);
801032b6:	83 ec 0c             	sub    $0xc,%esp
801032b9:	50                   	push   %eax
801032ba:	e8 81 db ff ff       	call   80100e40 <fileclose>
  if(*f1)
801032bf:	8b 06                	mov    (%esi),%eax
    fileclose(*f0);
801032c1:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801032c4:	85 c0                	test   %eax,%eax
801032c6:	75 c6                	jne    8010328e <pipealloc+0x4e>
801032c8:	eb d0                	jmp    8010329a <pipealloc+0x5a>
801032ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  initlock(&p->lock, "pipe");
801032d0:	83 ec 08             	sub    $0x8,%esp
  p->readopen = 1;
801032d3:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801032da:	00 00 00 
  p->writeopen = 1;
801032dd:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801032e4:	00 00 00 
  p->nwrite = 0;
801032e7:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801032ee:	00 00 00 
  p->nread = 0;
801032f1:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801032f8:	00 00 00 
  initlock(&p->lock, "pipe");
801032fb:	68 50 88 10 80       	push   $0x80108850
80103300:	50                   	push   %eax
80103301:	e8 ca 21 00 00       	call   801054d0 <initlock>
  (*f0)->type = FD_PIPE;
80103306:	8b 03                	mov    (%ebx),%eax
  return 0;
80103308:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
8010330b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103311:	8b 03                	mov    (%ebx),%eax
80103313:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103317:	8b 03                	mov    (%ebx),%eax
80103319:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
8010331d:	8b 03                	mov    (%ebx),%eax
8010331f:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103322:	8b 06                	mov    (%esi),%eax
80103324:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
8010332a:	8b 06                	mov    (%esi),%eax
8010332c:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103330:	8b 06                	mov    (%esi),%eax
80103332:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103336:	8b 06                	mov    (%esi),%eax
80103338:	89 78 0c             	mov    %edi,0xc(%eax)
}
8010333b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010333e:	31 c0                	xor    %eax,%eax
}
80103340:	5b                   	pop    %ebx
80103341:	5e                   	pop    %esi
80103342:	5f                   	pop    %edi
80103343:	5d                   	pop    %ebp
80103344:	c3                   	ret    
80103345:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103349:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103350 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103350:	55                   	push   %ebp
80103351:	89 e5                	mov    %esp,%ebp
80103353:	56                   	push   %esi
80103354:	53                   	push   %ebx
80103355:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103358:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010335b:	83 ec 0c             	sub    $0xc,%esp
8010335e:	53                   	push   %ebx
8010335f:	e8 ac 22 00 00       	call   80105610 <acquire>
  if(writable){
80103364:	83 c4 10             	add    $0x10,%esp
80103367:	85 f6                	test   %esi,%esi
80103369:	74 45                	je     801033b0 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010336b:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103371:	83 ec 0c             	sub    $0xc,%esp
    p->writeopen = 0;
80103374:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010337b:	00 00 00 
    wakeup(&p->nread);
8010337e:	50                   	push   %eax
8010337f:	e8 2c 1c 00 00       	call   80104fb0 <wakeup>
80103384:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103387:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010338d:	85 d2                	test   %edx,%edx
8010338f:	75 0a                	jne    8010339b <pipeclose+0x4b>
80103391:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103397:	85 c0                	test   %eax,%eax
80103399:	74 35                	je     801033d0 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010339b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010339e:	8d 65 f8             	lea    -0x8(%ebp),%esp
801033a1:	5b                   	pop    %ebx
801033a2:	5e                   	pop    %esi
801033a3:	5d                   	pop    %ebp
    release(&p->lock);
801033a4:	e9 27 23 00 00       	jmp    801056d0 <release>
801033a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
801033b0:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
801033b6:	83 ec 0c             	sub    $0xc,%esp
    p->readopen = 0;
801033b9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801033c0:	00 00 00 
    wakeup(&p->nwrite);
801033c3:	50                   	push   %eax
801033c4:	e8 e7 1b 00 00       	call   80104fb0 <wakeup>
801033c9:	83 c4 10             	add    $0x10,%esp
801033cc:	eb b9                	jmp    80103387 <pipeclose+0x37>
801033ce:	66 90                	xchg   %ax,%ax
    release(&p->lock);
801033d0:	83 ec 0c             	sub    $0xc,%esp
801033d3:	53                   	push   %ebx
801033d4:	e8 f7 22 00 00       	call   801056d0 <release>
    kfree((char*)p);
801033d9:	89 5d 08             	mov    %ebx,0x8(%ebp)
801033dc:	83 c4 10             	add    $0x10,%esp
}
801033df:	8d 65 f8             	lea    -0x8(%ebp),%esp
801033e2:	5b                   	pop    %ebx
801033e3:	5e                   	pop    %esi
801033e4:	5d                   	pop    %ebp
    kfree((char*)p);
801033e5:	e9 26 ef ff ff       	jmp    80102310 <kfree>
801033ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801033f0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801033f0:	55                   	push   %ebp
801033f1:	89 e5                	mov    %esp,%ebp
801033f3:	57                   	push   %edi
801033f4:	56                   	push   %esi
801033f5:	53                   	push   %ebx
801033f6:	83 ec 28             	sub    $0x28,%esp
801033f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801033fc:	53                   	push   %ebx
801033fd:	e8 0e 22 00 00       	call   80105610 <acquire>
  for(i = 0; i < n; i++){
80103402:	8b 45 10             	mov    0x10(%ebp),%eax
80103405:	83 c4 10             	add    $0x10,%esp
80103408:	85 c0                	test   %eax,%eax
8010340a:	0f 8e c9 00 00 00    	jle    801034d9 <pipewrite+0xe9>
80103410:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103413:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103419:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
8010341f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103422:	03 4d 10             	add    0x10(%ebp),%ecx
80103425:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103428:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
8010342e:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
80103434:	39 d0                	cmp    %edx,%eax
80103436:	75 71                	jne    801034a9 <pipewrite+0xb9>
      if(p->readopen == 0 || myproc()->killed){
80103438:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
8010343e:	85 c0                	test   %eax,%eax
80103440:	74 4e                	je     80103490 <pipewrite+0xa0>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103442:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103448:	eb 3a                	jmp    80103484 <pipewrite+0x94>
8010344a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      wakeup(&p->nread);
80103450:	83 ec 0c             	sub    $0xc,%esp
80103453:	57                   	push   %edi
80103454:	e8 57 1b 00 00       	call   80104fb0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103459:	5a                   	pop    %edx
8010345a:	59                   	pop    %ecx
8010345b:	53                   	push   %ebx
8010345c:	56                   	push   %esi
8010345d:	e8 2e 18 00 00       	call   80104c90 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103462:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103468:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010346e:	83 c4 10             	add    $0x10,%esp
80103471:	05 00 02 00 00       	add    $0x200,%eax
80103476:	39 c2                	cmp    %eax,%edx
80103478:	75 36                	jne    801034b0 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
8010347a:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103480:	85 c0                	test   %eax,%eax
80103482:	74 0c                	je     80103490 <pipewrite+0xa0>
80103484:	e8 17 04 00 00       	call   801038a0 <myproc>
80103489:	8b 40 24             	mov    0x24(%eax),%eax
8010348c:	85 c0                	test   %eax,%eax
8010348e:	74 c0                	je     80103450 <pipewrite+0x60>
        release(&p->lock);
80103490:	83 ec 0c             	sub    $0xc,%esp
80103493:	53                   	push   %ebx
80103494:	e8 37 22 00 00       	call   801056d0 <release>
        return -1;
80103499:	83 c4 10             	add    $0x10,%esp
8010349c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
801034a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801034a4:	5b                   	pop    %ebx
801034a5:	5e                   	pop    %esi
801034a6:	5f                   	pop    %edi
801034a7:	5d                   	pop    %ebp
801034a8:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801034a9:	89 c2                	mov    %eax,%edx
801034ab:	90                   	nop
801034ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801034b0:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801034b3:	8d 42 01             	lea    0x1(%edx),%eax
801034b6:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801034bc:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
801034c2:	83 c6 01             	add    $0x1,%esi
801034c5:	0f b6 4e ff          	movzbl -0x1(%esi),%ecx
  for(i = 0; i < n; i++){
801034c9:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801034cc:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801034cf:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801034d3:	0f 85 4f ff ff ff    	jne    80103428 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801034d9:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801034df:	83 ec 0c             	sub    $0xc,%esp
801034e2:	50                   	push   %eax
801034e3:	e8 c8 1a 00 00       	call   80104fb0 <wakeup>
  release(&p->lock);
801034e8:	89 1c 24             	mov    %ebx,(%esp)
801034eb:	e8 e0 21 00 00       	call   801056d0 <release>
  return n;
801034f0:	83 c4 10             	add    $0x10,%esp
801034f3:	8b 45 10             	mov    0x10(%ebp),%eax
801034f6:	eb a9                	jmp    801034a1 <pipewrite+0xb1>
801034f8:	90                   	nop
801034f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103500 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103500:	55                   	push   %ebp
80103501:	89 e5                	mov    %esp,%ebp
80103503:	57                   	push   %edi
80103504:	56                   	push   %esi
80103505:	53                   	push   %ebx
80103506:	83 ec 18             	sub    $0x18,%esp
80103509:	8b 75 08             	mov    0x8(%ebp),%esi
8010350c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010350f:	56                   	push   %esi
80103510:	e8 fb 20 00 00       	call   80105610 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103515:	83 c4 10             	add    $0x10,%esp
80103518:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
8010351e:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103524:	75 6a                	jne    80103590 <piperead+0x90>
80103526:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
8010352c:	85 db                	test   %ebx,%ebx
8010352e:	0f 84 c4 00 00 00    	je     801035f8 <piperead+0xf8>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103534:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
8010353a:	eb 2d                	jmp    80103569 <piperead+0x69>
8010353c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103540:	83 ec 08             	sub    $0x8,%esp
80103543:	56                   	push   %esi
80103544:	53                   	push   %ebx
80103545:	e8 46 17 00 00       	call   80104c90 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010354a:	83 c4 10             	add    $0x10,%esp
8010354d:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103553:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103559:	75 35                	jne    80103590 <piperead+0x90>
8010355b:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103561:	85 d2                	test   %edx,%edx
80103563:	0f 84 8f 00 00 00    	je     801035f8 <piperead+0xf8>
    if(myproc()->killed){
80103569:	e8 32 03 00 00       	call   801038a0 <myproc>
8010356e:	8b 48 24             	mov    0x24(%eax),%ecx
80103571:	85 c9                	test   %ecx,%ecx
80103573:	74 cb                	je     80103540 <piperead+0x40>
      release(&p->lock);
80103575:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103578:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
8010357d:	56                   	push   %esi
8010357e:	e8 4d 21 00 00       	call   801056d0 <release>
      return -1;
80103583:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103586:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103589:	89 d8                	mov    %ebx,%eax
8010358b:	5b                   	pop    %ebx
8010358c:	5e                   	pop    %esi
8010358d:	5f                   	pop    %edi
8010358e:	5d                   	pop    %ebp
8010358f:	c3                   	ret    
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103590:	8b 45 10             	mov    0x10(%ebp),%eax
80103593:	85 c0                	test   %eax,%eax
80103595:	7e 61                	jle    801035f8 <piperead+0xf8>
    if(p->nread == p->nwrite)
80103597:	31 db                	xor    %ebx,%ebx
80103599:	eb 13                	jmp    801035ae <piperead+0xae>
8010359b:	90                   	nop
8010359c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801035a0:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
801035a6:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
801035ac:	74 1f                	je     801035cd <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
801035ae:	8d 41 01             	lea    0x1(%ecx),%eax
801035b1:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
801035b7:	89 86 34 02 00 00    	mov    %eax,0x234(%esi)
801035bd:	0f b6 44 0e 34       	movzbl 0x34(%esi,%ecx,1),%eax
801035c2:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801035c5:	83 c3 01             	add    $0x1,%ebx
801035c8:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801035cb:	75 d3                	jne    801035a0 <piperead+0xa0>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801035cd:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
801035d3:	83 ec 0c             	sub    $0xc,%esp
801035d6:	50                   	push   %eax
801035d7:	e8 d4 19 00 00       	call   80104fb0 <wakeup>
  release(&p->lock);
801035dc:	89 34 24             	mov    %esi,(%esp)
801035df:	e8 ec 20 00 00       	call   801056d0 <release>
  return i;
801035e4:	83 c4 10             	add    $0x10,%esp
}
801035e7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801035ea:	89 d8                	mov    %ebx,%eax
801035ec:	5b                   	pop    %ebx
801035ed:	5e                   	pop    %esi
801035ee:	5f                   	pop    %edi
801035ef:	5d                   	pop    %ebp
801035f0:	c3                   	ret    
801035f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801035f8:	31 db                	xor    %ebx,%ebx
801035fa:	eb d1                	jmp    801035cd <piperead+0xcd>
801035fc:	66 90                	xchg   %ax,%ax
801035fe:	66 90                	xchg   %ax,%ax

80103600 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc *
allocproc(void)
{
80103600:	55                   	push   %ebp
80103601:	89 e5                	mov    %esp,%ebp
80103603:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103604:	bb 74 51 11 80       	mov    $0x80115174,%ebx
{
80103609:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
8010360c:	68 40 51 11 80       	push   $0x80115140
80103611:	e8 fa 1f 00 00       	call   80105610 <acquire>
80103616:	83 c4 10             	add    $0x10,%esp
80103619:	eb 17                	jmp    80103632 <allocproc+0x32>
8010361b:	90                   	nop
8010361c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103620:	81 c3 bc 00 00 00    	add    $0xbc,%ebx
80103626:	81 fb 74 80 11 80    	cmp    $0x80118074,%ebx
8010362c:	0f 83 36 01 00 00    	jae    80103768 <allocproc+0x168>
    if (p->state == UNUSED)
80103632:	8b 43 0c             	mov    0xc(%ebx),%eax
80103635:	85 c0                	test   %eax,%eax
80103637:	75 e7                	jne    80103620 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103639:	a1 04 c0 10 80       	mov    0x8010c004,%eax
  // p->start = ticks;
  p->waittime = 5;

  c0++;
  q0[c0] = p;
  release(&ptable.lock);
8010363e:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80103641:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->current_queue = 0;
80103648:	c7 83 b8 00 00 00 00 	movl   $0x0,0xb8(%ebx)
8010364f:	00 00 00 
  p->ticks[0] = 0;
80103652:	c7 83 94 00 00 00 00 	movl   $0x0,0x94(%ebx)
80103659:	00 00 00 
  p->ticks[1] = 0;
8010365c:	c7 83 98 00 00 00 00 	movl   $0x0,0x98(%ebx)
80103663:	00 00 00 
  p->ticks[2] = 0;
80103666:	c7 83 9c 00 00 00 00 	movl   $0x0,0x9c(%ebx)
8010366d:	00 00 00 
  p->pid = nextpid++;
80103670:	8d 50 01             	lea    0x1(%eax),%edx
80103673:	89 43 10             	mov    %eax,0x10(%ebx)
  c0++;
80103676:	a1 2c c0 10 80       	mov    0x8010c02c,%eax
  p->ticks[3] = 0;
8010367b:	c7 83 a0 00 00 00 00 	movl   $0x0,0xa0(%ebx)
80103682:	00 00 00 
  p->ticks[4] = 0;
80103685:	c7 83 a4 00 00 00 00 	movl   $0x0,0xa4(%ebx)
8010368c:	00 00 00 
  p->waittime = 5;
8010368f:	c7 83 b4 00 00 00 05 	movl   $0x5,0xb4(%ebx)
80103696:	00 00 00 
  release(&ptable.lock);
80103699:	68 40 51 11 80       	push   $0x80115140
  c0++;
8010369e:	83 c0 01             	add    $0x1,%eax
  p->pid = nextpid++;
801036a1:	89 15 04 c0 10 80    	mov    %edx,0x8010c004
  c0++;
801036a7:	a3 2c c0 10 80       	mov    %eax,0x8010c02c
  q0[c0] = p;
801036ac:	89 1c 85 40 50 11 80 	mov    %ebx,-0x7feeafc0(,%eax,4)
  release(&ptable.lock);
801036b3:	e8 18 20 00 00       	call   801056d0 <release>

  // Allocate kernel stack.
  if ((p->kstack = kalloc()) == 0)
801036b8:	e8 03 ee ff ff       	call   801024c0 <kalloc>
801036bd:	83 c4 10             	add    $0x10,%esp
801036c0:	85 c0                	test   %eax,%eax
801036c2:	89 43 08             	mov    %eax,0x8(%ebx)
801036c5:	0f 84 b6 00 00 00    	je     80103781 <allocproc+0x181>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801036cb:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint *)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context *)sp;
  memset(p->context, 0, sizeof *p->context);
801036d1:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
801036d4:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
801036d9:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint *)sp = (uint)trapret;
801036dc:	c7 40 14 0f 6a 10 80 	movl   $0x80106a0f,0x14(%eax)
  p->context = (struct context *)sp;
801036e3:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
801036e6:	6a 14                	push   $0x14
801036e8:	6a 00                	push   $0x0
801036ea:	50                   	push   %eax
801036eb:	e8 30 20 00 00       	call   80105720 <memset>
  p->context->eip = (uint)forkret;
801036f0:	8b 43 1c             	mov    0x1c(%ebx),%eax
801036f3:	c7 40 10 90 37 10 80 	movl   $0x80103790,0x10(%eax)

  acquire(&ptable.lock);
801036fa:	c7 04 24 40 51 11 80 	movl   $0x80115140,(%esp)
80103701:	e8 0a 1f 00 00       	call   80105610 <acquire>
  p->ctime = ticks; // TODO Might need to protect the read of ticks with a lock
80103706:	a1 c0 89 11 80       	mov    0x801189c0,%eax
  p->etime = 0;
8010370b:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
80103712:	00 00 00 
  p->rtime = 0;
80103715:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
8010371c:	00 00 00 
  p->iotime = 0;
8010371f:	c7 83 88 00 00 00 00 	movl   $0x0,0x88(%ebx)
80103726:	00 00 00 
  p->num_run = 0;
80103729:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80103730:	00 00 00 
  p->ctime = ticks; // TODO Might need to protect the read of ticks with a lock
80103733:	89 43 7c             	mov    %eax,0x7c(%ebx)
  release(&ptable.lock);
80103736:	c7 04 24 40 51 11 80 	movl   $0x80115140,(%esp)
8010373d:	e8 8e 1f 00 00       	call   801056d0 <release>

  if (p->pid == 1 || p->pid == 2)
80103742:	8b 43 10             	mov    0x10(%ebx),%eax
80103745:	83 c4 10             	add    $0x10,%esp
80103748:	83 e8 01             	sub    $0x1,%eax
    p->priority = 1;
8010374b:	83 f8 02             	cmp    $0x2,%eax
8010374e:	19 c0                	sbb    %eax,%eax
80103750:	83 e0 c5             	and    $0xffffffc5,%eax
80103753:	83 c0 3c             	add    $0x3c,%eax
80103756:	89 83 90 00 00 00    	mov    %eax,0x90(%ebx)
  else
    p->priority = 60;
  return p;
}
8010375c:	89 d8                	mov    %ebx,%eax
8010375e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103761:	c9                   	leave  
80103762:	c3                   	ret    
80103763:	90                   	nop
80103764:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80103768:	83 ec 0c             	sub    $0xc,%esp
  return 0;
8010376b:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
8010376d:	68 40 51 11 80       	push   $0x80115140
80103772:	e8 59 1f 00 00       	call   801056d0 <release>
}
80103777:	89 d8                	mov    %ebx,%eax
  return 0;
80103779:	83 c4 10             	add    $0x10,%esp
}
8010377c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010377f:	c9                   	leave  
80103780:	c3                   	ret    
    p->state = UNUSED;
80103781:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103788:	31 db                	xor    %ebx,%ebx
8010378a:	eb d0                	jmp    8010375c <allocproc+0x15c>
8010378c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103790 <forkret>:
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void forkret(void)
{
80103790:	55                   	push   %ebp
80103791:	89 e5                	mov    %esp,%ebp
80103793:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103796:	68 40 51 11 80       	push   $0x80115140
8010379b:	e8 30 1f 00 00       	call   801056d0 <release>

  if (first)
801037a0:	a1 00 c0 10 80       	mov    0x8010c000,%eax
801037a5:	83 c4 10             	add    $0x10,%esp
801037a8:	85 c0                	test   %eax,%eax
801037aa:	75 04                	jne    801037b0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801037ac:	c9                   	leave  
801037ad:	c3                   	ret    
801037ae:	66 90                	xchg   %ax,%ax
    iinit(ROOTDEV);
801037b0:	83 ec 0c             	sub    $0xc,%esp
    first = 0;
801037b3:	c7 05 00 c0 10 80 00 	movl   $0x0,0x8010c000
801037ba:	00 00 00 
    iinit(ROOTDEV);
801037bd:	6a 01                	push   $0x1
801037bf:	e8 bc dc ff ff       	call   80101480 <iinit>
    initlog(ROOTDEV);
801037c4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801037cb:	e8 30 f3 ff ff       	call   80102b00 <initlog>
801037d0:	83 c4 10             	add    $0x10,%esp
}
801037d3:	c9                   	leave  
801037d4:	c3                   	ret    
801037d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801037d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801037e0 <pinit>:
{
801037e0:	55                   	push   %ebp
801037e1:	89 e5                	mov    %esp,%ebp
801037e3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
801037e6:	68 55 88 10 80       	push   $0x80108855
801037eb:	68 40 51 11 80       	push   $0x80115140
801037f0:	e8 db 1c 00 00       	call   801054d0 <initlock>
}
801037f5:	83 c4 10             	add    $0x10,%esp
801037f8:	c9                   	leave  
801037f9:	c3                   	ret    
801037fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103800 <mycpu>:
{
80103800:	55                   	push   %ebp
80103801:	89 e5                	mov    %esp,%ebp
80103803:	56                   	push   %esi
80103804:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103805:	9c                   	pushf  
80103806:	58                   	pop    %eax
  if (readeflags() & FL_IF)
80103807:	f6 c4 02             	test   $0x2,%ah
8010380a:	75 5e                	jne    8010386a <mycpu+0x6a>
  apicid = lapicid();
8010380c:	e8 1f ef ff ff       	call   80102730 <lapicid>
  for (i = 0; i < ncpu; ++i)
80103811:	8b 35 20 4d 11 80    	mov    0x80114d20,%esi
80103817:	85 f6                	test   %esi,%esi
80103819:	7e 42                	jle    8010385d <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
8010381b:	0f b6 15 a0 47 11 80 	movzbl 0x801147a0,%edx
80103822:	39 d0                	cmp    %edx,%eax
80103824:	74 30                	je     80103856 <mycpu+0x56>
80103826:	b9 50 48 11 80       	mov    $0x80114850,%ecx
  for (i = 0; i < ncpu; ++i)
8010382b:	31 d2                	xor    %edx,%edx
8010382d:	8d 76 00             	lea    0x0(%esi),%esi
80103830:	83 c2 01             	add    $0x1,%edx
80103833:	39 f2                	cmp    %esi,%edx
80103835:	74 26                	je     8010385d <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
80103837:	0f b6 19             	movzbl (%ecx),%ebx
8010383a:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103840:	39 c3                	cmp    %eax,%ebx
80103842:	75 ec                	jne    80103830 <mycpu+0x30>
80103844:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
8010384a:	05 a0 47 11 80       	add    $0x801147a0,%eax
}
8010384f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103852:	5b                   	pop    %ebx
80103853:	5e                   	pop    %esi
80103854:	5d                   	pop    %ebp
80103855:	c3                   	ret    
    if (cpus[i].apicid == apicid)
80103856:	b8 a0 47 11 80       	mov    $0x801147a0,%eax
      return &cpus[i];
8010385b:	eb f2                	jmp    8010384f <mycpu+0x4f>
  panic("unknown apicid\n");
8010385d:	83 ec 0c             	sub    $0xc,%esp
80103860:	68 5c 88 10 80       	push   $0x8010885c
80103865:	e8 26 cb ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
8010386a:	83 ec 0c             	sub    $0xc,%esp
8010386d:	68 84 89 10 80       	push   $0x80108984
80103872:	e8 19 cb ff ff       	call   80100390 <panic>
80103877:	89 f6                	mov    %esi,%esi
80103879:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103880 <cpuid>:
{
80103880:	55                   	push   %ebp
80103881:	89 e5                	mov    %esp,%ebp
80103883:	83 ec 08             	sub    $0x8,%esp
  return mycpu() - cpus;
80103886:	e8 75 ff ff ff       	call   80103800 <mycpu>
8010388b:	2d a0 47 11 80       	sub    $0x801147a0,%eax
}
80103890:	c9                   	leave  
  return mycpu() - cpus;
80103891:	c1 f8 04             	sar    $0x4,%eax
80103894:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010389a:	c3                   	ret    
8010389b:	90                   	nop
8010389c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801038a0 <myproc>:
{
801038a0:	55                   	push   %ebp
801038a1:	89 e5                	mov    %esp,%ebp
801038a3:	53                   	push   %ebx
801038a4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
801038a7:	e8 94 1c 00 00       	call   80105540 <pushcli>
  c = mycpu();
801038ac:	e8 4f ff ff ff       	call   80103800 <mycpu>
  p = c->proc;
801038b1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801038b7:	e8 c4 1c 00 00       	call   80105580 <popcli>
}
801038bc:	83 c4 04             	add    $0x4,%esp
801038bf:	89 d8                	mov    %ebx,%eax
801038c1:	5b                   	pop    %ebx
801038c2:	5d                   	pop    %ebp
801038c3:	c3                   	ret    
801038c4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801038ca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801038d0 <rem_process>:
{
801038d0:	55                   	push   %ebp
801038d1:	89 e5                	mov    %esp,%ebp
801038d3:	57                   	push   %edi
801038d4:	56                   	push   %esi
801038d5:	8b 55 0c             	mov    0xc(%ebp),%edx
801038d8:	53                   	push   %ebx
801038d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(curq==0)
801038dc:	85 d2                	test   %edx,%edx
801038de:	75 70                	jne    80103950 <rem_process+0x80>
    for(int i=0; i<=c0; i++)
801038e0:	8b 35 2c c0 10 80    	mov    0x8010c02c,%esi
801038e6:	31 c9                	xor    %ecx,%ecx
801038e8:	85 f6                	test   %esi,%esi
801038ea:	79 44                	jns    80103930 <rem_process+0x60>
}
801038ec:	5b                   	pop    %ebx
801038ed:	5e                   	pop    %esi
801038ee:	5f                   	pop    %edi
801038ef:	5d                   	pop    %ebp
801038f0:	c3                   	ret    
801038f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        for (int j = i; j <= c0 - 1; j++)
801038f8:	39 d6                	cmp    %edx,%esi
801038fa:	7e 21                	jle    8010391d <rem_process+0x4d>
801038fc:	8d 04 95 40 50 11 80 	lea    -0x7feeafc0(,%edx,4),%eax
80103903:	8d 3c b5 40 50 11 80 	lea    -0x7feeafc0(,%esi,4),%edi
8010390a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            q0[j] = q0[j + 1];
80103910:	8b 48 04             	mov    0x4(%eax),%ecx
80103913:	83 c0 04             	add    $0x4,%eax
80103916:	89 48 fc             	mov    %ecx,-0x4(%eax)
        for (int j = i; j <= c0 - 1; j++)
80103919:	39 f8                	cmp    %edi,%eax
8010391b:	75 f3                	jne    80103910 <rem_process+0x40>
        c0--;
8010391d:	83 ee 01             	sub    $0x1,%esi
    for(int i=0; i<=c0; i++)
80103920:	83 c2 01             	add    $0x1,%edx
        c0--;
80103923:	b9 01 00 00 00       	mov    $0x1,%ecx
    for(int i=0; i<=c0; i++)
80103928:	39 d6                	cmp    %edx,%esi
8010392a:	7c 17                	jl     80103943 <rem_process+0x73>
8010392c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(q0[i]->pid==pid)
80103930:	8b 04 95 40 50 11 80 	mov    -0x7feeafc0(,%edx,4),%eax
80103937:	39 58 10             	cmp    %ebx,0x10(%eax)
8010393a:	74 bc                	je     801038f8 <rem_process+0x28>
    for(int i=0; i<=c0; i++)
8010393c:	83 c2 01             	add    $0x1,%edx
8010393f:	39 d6                	cmp    %edx,%esi
80103941:	7d ed                	jge    80103930 <rem_process+0x60>
80103943:	84 c9                	test   %cl,%cl
80103945:	74 a5                	je     801038ec <rem_process+0x1c>
80103947:	89 35 2c c0 10 80    	mov    %esi,0x8010c02c
}
8010394d:	eb 9d                	jmp    801038ec <rem_process+0x1c>
8010394f:	90                   	nop
  else if(curq==1)
80103950:	83 fa 01             	cmp    $0x1,%edx
80103953:	74 7b                	je     801039d0 <rem_process+0x100>
  else if(curq==2)
80103955:	83 fa 02             	cmp    $0x2,%edx
80103958:	0f 84 42 01 00 00    	je     80103aa0 <rem_process+0x1d0>
  else if(curq==3)
8010395e:	83 fa 03             	cmp    $0x3,%edx
80103961:	0f 84 d9 00 00 00    	je     80103a40 <rem_process+0x170>
  else if(curq==4)
80103967:	83 fa 04             	cmp    $0x4,%edx
8010396a:	75 80                	jne    801038ec <rem_process+0x1c>
    for(int i=0; i<=c4; i++)
8010396c:	8b 35 1c c0 10 80    	mov    0x8010c01c,%esi
80103972:	85 f6                	test   %esi,%esi
80103974:	0f 88 72 ff ff ff    	js     801038ec <rem_process+0x1c>
8010397a:	31 c9                	xor    %ecx,%ecx
8010397c:	31 d2                	xor    %edx,%edx
8010397e:	eb 0b                	jmp    8010398b <rem_process+0xbb>
80103980:	83 c2 01             	add    $0x1,%edx
80103983:	39 f2                	cmp    %esi,%edx
80103985:	0f 8f a5 01 00 00    	jg     80103b30 <rem_process+0x260>
      if(q4[i]->pid==pid)
8010398b:	8b 04 95 80 80 11 80 	mov    -0x7fee7f80(,%edx,4),%eax
80103992:	3b 58 10             	cmp    0x10(%eax),%ebx
80103995:	75 e9                	jne    80103980 <rem_process+0xb0>
        for (int j = i; j <= c4 - 1; j++)
80103997:	39 f2                	cmp    %esi,%edx
80103999:	7d 22                	jge    801039bd <rem_process+0xed>
8010399b:	8d 04 95 80 80 11 80 	lea    -0x7fee7f80(,%edx,4),%eax
801039a2:	8d 3c b5 80 80 11 80 	lea    -0x7fee7f80(,%esi,4),%edi
801039a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            q4[j] = q4[j + 1];
801039b0:	8b 48 04             	mov    0x4(%eax),%ecx
801039b3:	83 c0 04             	add    $0x4,%eax
801039b6:	89 48 fc             	mov    %ecx,-0x4(%eax)
        for (int j = i; j <= c4 - 1; j++)
801039b9:	39 f8                	cmp    %edi,%eax
801039bb:	75 f3                	jne    801039b0 <rem_process+0xe0>
        c4--;
801039bd:	83 ee 01             	sub    $0x1,%esi
801039c0:	b9 01 00 00 00       	mov    $0x1,%ecx
801039c5:	eb b9                	jmp    80103980 <rem_process+0xb0>
801039c7:	89 f6                	mov    %esi,%esi
801039c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    for(int i=0; i<=c1; i++)
801039d0:	8b 35 28 c0 10 80    	mov    0x8010c028,%esi
801039d6:	85 f6                	test   %esi,%esi
801039d8:	0f 88 0e ff ff ff    	js     801038ec <rem_process+0x1c>
801039de:	31 c9                	xor    %ecx,%ecx
801039e0:	31 d2                	xor    %edx,%edx
801039e2:	eb 0b                	jmp    801039ef <rem_process+0x11f>
801039e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801039e8:	83 c2 01             	add    $0x1,%edx
801039eb:	39 f2                	cmp    %esi,%edx
801039ed:	7f 3d                	jg     80103a2c <rem_process+0x15c>
      if(q1[i]->pid==pid)
801039ef:	8b 04 95 40 4f 11 80 	mov    -0x7feeb0c0(,%edx,4),%eax
801039f6:	39 58 10             	cmp    %ebx,0x10(%eax)
801039f9:	75 ed                	jne    801039e8 <rem_process+0x118>
        for (int j = i; j <= c1 - 1; j++)
801039fb:	39 d6                	cmp    %edx,%esi
801039fd:	7e 1e                	jle    80103a1d <rem_process+0x14d>
801039ff:	8d 04 95 40 4f 11 80 	lea    -0x7feeb0c0(,%edx,4),%eax
80103a06:	8d 3c b5 40 4f 11 80 	lea    -0x7feeb0c0(,%esi,4),%edi
80103a0d:	8d 76 00             	lea    0x0(%esi),%esi
            q1[j] = q1[j + 1];
80103a10:	8b 48 04             	mov    0x4(%eax),%ecx
80103a13:	83 c0 04             	add    $0x4,%eax
80103a16:	89 48 fc             	mov    %ecx,-0x4(%eax)
        for (int j = i; j <= c1 - 1; j++)
80103a19:	39 c7                	cmp    %eax,%edi
80103a1b:	75 f3                	jne    80103a10 <rem_process+0x140>
        c1--;
80103a1d:	83 ee 01             	sub    $0x1,%esi
    for(int i=0; i<=c1; i++)
80103a20:	83 c2 01             	add    $0x1,%edx
        c1--;
80103a23:	b9 01 00 00 00       	mov    $0x1,%ecx
    for(int i=0; i<=c1; i++)
80103a28:	39 f2                	cmp    %esi,%edx
80103a2a:	7e c3                	jle    801039ef <rem_process+0x11f>
80103a2c:	84 c9                	test   %cl,%cl
80103a2e:	0f 84 b8 fe ff ff    	je     801038ec <rem_process+0x1c>
80103a34:	89 35 28 c0 10 80    	mov    %esi,0x8010c028
80103a3a:	e9 ad fe ff ff       	jmp    801038ec <rem_process+0x1c>
80103a3f:	90                   	nop
    for(int i=0; i<=c3; i++)
80103a40:	8b 35 20 c0 10 80    	mov    0x8010c020,%esi
80103a46:	85 f6                	test   %esi,%esi
80103a48:	0f 88 9e fe ff ff    	js     801038ec <rem_process+0x1c>
80103a4e:	31 c9                	xor    %ecx,%ecx
80103a50:	31 d2                	xor    %edx,%edx
80103a52:	eb 0f                	jmp    80103a63 <rem_process+0x193>
80103a54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103a58:	83 c2 01             	add    $0x1,%edx
80103a5b:	39 f2                	cmp    %esi,%edx
80103a5d:	0f 8f b5 00 00 00    	jg     80103b18 <rem_process+0x248>
      if(q3[i]->pid==pid)
80103a63:	8b 04 95 40 4e 11 80 	mov    -0x7feeb1c0(,%edx,4),%eax
80103a6a:	3b 58 10             	cmp    0x10(%eax),%ebx
80103a6d:	75 e9                	jne    80103a58 <rem_process+0x188>
        for (int j = i; j <= c3 - 1; j++)
80103a6f:	39 f2                	cmp    %esi,%edx
80103a71:	7d 22                	jge    80103a95 <rem_process+0x1c5>
80103a73:	8d 04 95 40 4e 11 80 	lea    -0x7feeb1c0(,%edx,4),%eax
80103a7a:	8d 3c b5 40 4e 11 80 	lea    -0x7feeb1c0(,%esi,4),%edi
80103a81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            q3[j] = q3[j + 1];
80103a88:	8b 48 04             	mov    0x4(%eax),%ecx
80103a8b:	83 c0 04             	add    $0x4,%eax
80103a8e:	89 48 fc             	mov    %ecx,-0x4(%eax)
        for (int j = i; j <= c3 - 1; j++)
80103a91:	39 f8                	cmp    %edi,%eax
80103a93:	75 f3                	jne    80103a88 <rem_process+0x1b8>
        c3--;
80103a95:	83 ee 01             	sub    $0x1,%esi
80103a98:	b9 01 00 00 00       	mov    $0x1,%ecx
80103a9d:	eb b9                	jmp    80103a58 <rem_process+0x188>
80103a9f:	90                   	nop
    for(int i=0; i<=c2; i++)
80103aa0:	8b 35 24 c0 10 80    	mov    0x8010c024,%esi
80103aa6:	85 f6                	test   %esi,%esi
80103aa8:	0f 88 3e fe ff ff    	js     801038ec <rem_process+0x1c>
80103aae:	31 c9                	xor    %ecx,%ecx
80103ab0:	31 d2                	xor    %edx,%edx
80103ab2:	eb 0b                	jmp    80103abf <rem_process+0x1ef>
80103ab4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103ab8:	83 c2 01             	add    $0x1,%edx
80103abb:	39 f2                	cmp    %esi,%edx
80103abd:	7f 41                	jg     80103b00 <rem_process+0x230>
      if(q2[i]->pid==pid)
80103abf:	8b 04 95 40 4d 11 80 	mov    -0x7feeb2c0(,%edx,4),%eax
80103ac6:	3b 58 10             	cmp    0x10(%eax),%ebx
80103ac9:	75 ed                	jne    80103ab8 <rem_process+0x1e8>
        for (int j = i; j <= c2 - 1; j++)
80103acb:	39 f2                	cmp    %esi,%edx
80103acd:	7d 1e                	jge    80103aed <rem_process+0x21d>
80103acf:	8d 04 95 40 4d 11 80 	lea    -0x7feeb2c0(,%edx,4),%eax
80103ad6:	8d 3c b5 40 4d 11 80 	lea    -0x7feeb2c0(,%esi,4),%edi
80103add:	8d 76 00             	lea    0x0(%esi),%esi
            q2[j] = q2[j + 1];
80103ae0:	8b 48 04             	mov    0x4(%eax),%ecx
80103ae3:	83 c0 04             	add    $0x4,%eax
80103ae6:	89 48 fc             	mov    %ecx,-0x4(%eax)
        for (int j = i; j <= c2 - 1; j++)
80103ae9:	39 c7                	cmp    %eax,%edi
80103aeb:	75 f3                	jne    80103ae0 <rem_process+0x210>
        c2--;
80103aed:	83 ee 01             	sub    $0x1,%esi
80103af0:	b9 01 00 00 00       	mov    $0x1,%ecx
80103af5:	eb c1                	jmp    80103ab8 <rem_process+0x1e8>
80103af7:	89 f6                	mov    %esi,%esi
80103af9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80103b00:	84 c9                	test   %cl,%cl
80103b02:	0f 84 e4 fd ff ff    	je     801038ec <rem_process+0x1c>
80103b08:	89 35 24 c0 10 80    	mov    %esi,0x8010c024
80103b0e:	e9 d9 fd ff ff       	jmp    801038ec <rem_process+0x1c>
80103b13:	90                   	nop
80103b14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103b18:	84 c9                	test   %cl,%cl
80103b1a:	0f 84 cc fd ff ff    	je     801038ec <rem_process+0x1c>
80103b20:	89 35 20 c0 10 80    	mov    %esi,0x8010c020
80103b26:	e9 c1 fd ff ff       	jmp    801038ec <rem_process+0x1c>
80103b2b:	90                   	nop
80103b2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103b30:	84 c9                	test   %cl,%cl
80103b32:	0f 84 b4 fd ff ff    	je     801038ec <rem_process+0x1c>
80103b38:	89 35 1c c0 10 80    	mov    %esi,0x8010c01c
80103b3e:	e9 a9 fd ff ff       	jmp    801038ec <rem_process+0x1c>
80103b43:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103b49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103b50 <display_queues>:
{
80103b50:	55                   	push   %ebp
80103b51:	89 e5                	mov    %esp,%ebp
80103b53:	53                   	push   %ebx
80103b54:	83 ec 10             	sub    $0x10,%esp
  cprintf("\n\n\n******************************************");
80103b57:	68 ac 89 10 80       	push   $0x801089ac
80103b5c:	e8 ff ca ff ff       	call   80100660 <cprintf>
  if(c0!=-1){
80103b61:	83 c4 10             	add    $0x10,%esp
80103b64:	83 3d 2c c0 10 80 ff 	cmpl   $0xffffffff,0x8010c02c
80103b6b:	0f 85 bf 01 00 00    	jne    80103d30 <display_queues+0x1e0>
  if(c1!=-1){
80103b71:	83 3d 28 c0 10 80 ff 	cmpl   $0xffffffff,0x8010c028
80103b78:	0f 85 52 01 00 00    	jne    80103cd0 <display_queues+0x180>
  if(c2!=-1){
80103b7e:	83 3d 24 c0 10 80 ff 	cmpl   $0xffffffff,0x8010c024
80103b85:	0f 85 e5 00 00 00    	jne    80103c70 <display_queues+0x120>
  if(c3!=-1){
80103b8b:	83 3d 20 c0 10 80 ff 	cmpl   $0xffffffff,0x8010c020
80103b92:	75 7c                	jne    80103c10 <display_queues+0xc0>
  if(c4!=-1){
80103b94:	83 3d 1c c0 10 80 ff 	cmpl   $0xffffffff,0x8010c01c
80103b9b:	74 5c                	je     80103bf9 <display_queues+0xa9>
  cprintf("\nQUEUE----4\n");
80103b9d:	83 ec 0c             	sub    $0xc,%esp
80103ba0:	68 ac 88 10 80       	push   $0x801088ac
80103ba5:	e8 b6 ca ff ff       	call   80100660 <cprintf>
  for(int i=0; i<=c4; i++)
80103baa:	a1 1c c0 10 80       	mov    0x8010c01c,%eax
80103baf:	83 c4 10             	add    $0x10,%esp
80103bb2:	85 c0                	test   %eax,%eax
80103bb4:	78 33                	js     80103be9 <display_queues+0x99>
80103bb6:	31 db                	xor    %ebx,%ebx
80103bb8:	90                   	nop
80103bb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    cprintf("(%d,%s,%d)\t",q4[i]->pid, q4[i]->name, q4[i]->state);
80103bc0:	8b 04 9d 80 80 11 80 	mov    -0x7fee7f80(,%ebx,4),%eax
  for(int i=0; i<=c4; i++)
80103bc7:	83 c3 01             	add    $0x1,%ebx
    cprintf("(%d,%s,%d)\t",q4[i]->pid, q4[i]->name, q4[i]->state);
80103bca:	8d 50 6c             	lea    0x6c(%eax),%edx
80103bcd:	ff 70 0c             	pushl  0xc(%eax)
80103bd0:	52                   	push   %edx
80103bd1:	ff 70 10             	pushl  0x10(%eax)
80103bd4:	68 79 88 10 80       	push   $0x80108879
80103bd9:	e8 82 ca ff ff       	call   80100660 <cprintf>
  for(int i=0; i<=c4; i++)
80103bde:	83 c4 10             	add    $0x10,%esp
80103be1:	39 1d 1c c0 10 80    	cmp    %ebx,0x8010c01c
80103be7:	7d d7                	jge    80103bc0 <display_queues+0x70>
  cprintf("\n");
80103be9:	83 ec 0c             	sub    $0xc,%esp
80103bec:	68 37 90 10 80       	push   $0x80109037
80103bf1:	e8 6a ca ff ff       	call   80100660 <cprintf>
80103bf6:	83 c4 10             	add    $0x10,%esp
  cprintf("******************************************\n\n");
80103bf9:	83 ec 0c             	sub    $0xc,%esp
80103bfc:	68 dc 89 10 80       	push   $0x801089dc
80103c01:	e8 5a ca ff ff       	call   80100660 <cprintf>
}
80103c06:	83 c4 10             	add    $0x10,%esp
80103c09:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103c0c:	c9                   	leave  
80103c0d:	c3                   	ret    
80103c0e:	66 90                	xchg   %ax,%ax
  cprintf("\nQUEUE----3\n");
80103c10:	83 ec 0c             	sub    $0xc,%esp
80103c13:	68 9f 88 10 80       	push   $0x8010889f
80103c18:	e8 43 ca ff ff       	call   80100660 <cprintf>
  for(int i=0; i<=c3; i++)
80103c1d:	8b 15 20 c0 10 80    	mov    0x8010c020,%edx
80103c23:	83 c4 10             	add    $0x10,%esp
80103c26:	85 d2                	test   %edx,%edx
80103c28:	78 2f                	js     80103c59 <display_queues+0x109>
80103c2a:	31 db                	xor    %ebx,%ebx
80103c2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("(%d,%s,%d)\t",q3[i]->pid, q3[i]->name, q3[i]->state);
80103c30:	8b 04 9d 40 4e 11 80 	mov    -0x7feeb1c0(,%ebx,4),%eax
  for(int i=0; i<=c3; i++)
80103c37:	83 c3 01             	add    $0x1,%ebx
    cprintf("(%d,%s,%d)\t",q3[i]->pid, q3[i]->name, q3[i]->state);
80103c3a:	8d 50 6c             	lea    0x6c(%eax),%edx
80103c3d:	ff 70 0c             	pushl  0xc(%eax)
80103c40:	52                   	push   %edx
80103c41:	ff 70 10             	pushl  0x10(%eax)
80103c44:	68 79 88 10 80       	push   $0x80108879
80103c49:	e8 12 ca ff ff       	call   80100660 <cprintf>
  for(int i=0; i<=c3; i++)
80103c4e:	83 c4 10             	add    $0x10,%esp
80103c51:	39 1d 20 c0 10 80    	cmp    %ebx,0x8010c020
80103c57:	7d d7                	jge    80103c30 <display_queues+0xe0>
  cprintf("\n");
80103c59:	83 ec 0c             	sub    $0xc,%esp
80103c5c:	68 37 90 10 80       	push   $0x80109037
80103c61:	e8 fa c9 ff ff       	call   80100660 <cprintf>
80103c66:	83 c4 10             	add    $0x10,%esp
80103c69:	e9 26 ff ff ff       	jmp    80103b94 <display_queues+0x44>
80103c6e:	66 90                	xchg   %ax,%ax
  cprintf("\nQUEUE----2\n");
80103c70:	83 ec 0c             	sub    $0xc,%esp
80103c73:	68 92 88 10 80       	push   $0x80108892
80103c78:	e8 e3 c9 ff ff       	call   80100660 <cprintf>
  for(int i=0; i<=c2; i++)
80103c7d:	8b 0d 24 c0 10 80    	mov    0x8010c024,%ecx
80103c83:	83 c4 10             	add    $0x10,%esp
80103c86:	85 c9                	test   %ecx,%ecx
80103c88:	78 2f                	js     80103cb9 <display_queues+0x169>
80103c8a:	31 db                	xor    %ebx,%ebx
80103c8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("(%d,%s,%d)\t",q2[i]->pid, q2[i]->name, q2[i]->state);
80103c90:	8b 04 9d 40 4d 11 80 	mov    -0x7feeb2c0(,%ebx,4),%eax
  for(int i=0; i<=c2; i++)
80103c97:	83 c3 01             	add    $0x1,%ebx
    cprintf("(%d,%s,%d)\t",q2[i]->pid, q2[i]->name, q2[i]->state);
80103c9a:	8d 50 6c             	lea    0x6c(%eax),%edx
80103c9d:	ff 70 0c             	pushl  0xc(%eax)
80103ca0:	52                   	push   %edx
80103ca1:	ff 70 10             	pushl  0x10(%eax)
80103ca4:	68 79 88 10 80       	push   $0x80108879
80103ca9:	e8 b2 c9 ff ff       	call   80100660 <cprintf>
  for(int i=0; i<=c2; i++)
80103cae:	83 c4 10             	add    $0x10,%esp
80103cb1:	39 1d 24 c0 10 80    	cmp    %ebx,0x8010c024
80103cb7:	7d d7                	jge    80103c90 <display_queues+0x140>
  cprintf("\n");
80103cb9:	83 ec 0c             	sub    $0xc,%esp
80103cbc:	68 37 90 10 80       	push   $0x80109037
80103cc1:	e8 9a c9 ff ff       	call   80100660 <cprintf>
80103cc6:	83 c4 10             	add    $0x10,%esp
80103cc9:	e9 bd fe ff ff       	jmp    80103b8b <display_queues+0x3b>
80103cce:	66 90                	xchg   %ax,%ax
  cprintf("\nQUEUE----1\n");
80103cd0:	83 ec 0c             	sub    $0xc,%esp
80103cd3:	68 85 88 10 80       	push   $0x80108885
80103cd8:	e8 83 c9 ff ff       	call   80100660 <cprintf>
  for(int i=0; i<=c1; i++)
80103cdd:	8b 1d 28 c0 10 80    	mov    0x8010c028,%ebx
80103ce3:	83 c4 10             	add    $0x10,%esp
80103ce6:	85 db                	test   %ebx,%ebx
80103ce8:	78 2f                	js     80103d19 <display_queues+0x1c9>
80103cea:	31 db                	xor    %ebx,%ebx
80103cec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("(%d,%s,%d)\t",q1[i]->pid, q1[i]->name, q1[i]->state);
80103cf0:	8b 04 9d 40 4f 11 80 	mov    -0x7feeb0c0(,%ebx,4),%eax
  for(int i=0; i<=c1; i++)
80103cf7:	83 c3 01             	add    $0x1,%ebx
    cprintf("(%d,%s,%d)\t",q1[i]->pid, q1[i]->name, q1[i]->state);
80103cfa:	8d 50 6c             	lea    0x6c(%eax),%edx
80103cfd:	ff 70 0c             	pushl  0xc(%eax)
80103d00:	52                   	push   %edx
80103d01:	ff 70 10             	pushl  0x10(%eax)
80103d04:	68 79 88 10 80       	push   $0x80108879
80103d09:	e8 52 c9 ff ff       	call   80100660 <cprintf>
  for(int i=0; i<=c1; i++)
80103d0e:	83 c4 10             	add    $0x10,%esp
80103d11:	39 1d 28 c0 10 80    	cmp    %ebx,0x8010c028
80103d17:	7d d7                	jge    80103cf0 <display_queues+0x1a0>
  cprintf("\n");
80103d19:	83 ec 0c             	sub    $0xc,%esp
80103d1c:	68 37 90 10 80       	push   $0x80109037
80103d21:	e8 3a c9 ff ff       	call   80100660 <cprintf>
80103d26:	83 c4 10             	add    $0x10,%esp
80103d29:	e9 50 fe ff ff       	jmp    80103b7e <display_queues+0x2e>
80103d2e:	66 90                	xchg   %ax,%ax
  cprintf("\nQUEUE----0\n");
80103d30:	83 ec 0c             	sub    $0xc,%esp
80103d33:	68 6c 88 10 80       	push   $0x8010886c
80103d38:	e8 23 c9 ff ff       	call   80100660 <cprintf>
  for(int i=0; i<=c0; i++)
80103d3d:	a1 2c c0 10 80       	mov    0x8010c02c,%eax
80103d42:	83 c4 10             	add    $0x10,%esp
80103d45:	85 c0                	test   %eax,%eax
80103d47:	78 30                	js     80103d79 <display_queues+0x229>
80103d49:	31 db                	xor    %ebx,%ebx
80103d4b:	90                   	nop
80103d4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("(%d,%s,%d)\t",q0[i]->pid, q0[i]->name, q0[i]->state);
80103d50:	8b 04 9d 40 50 11 80 	mov    -0x7feeafc0(,%ebx,4),%eax
  for(int i=0; i<=c0; i++)
80103d57:	83 c3 01             	add    $0x1,%ebx
    cprintf("(%d,%s,%d)\t",q0[i]->pid, q0[i]->name, q0[i]->state);
80103d5a:	8d 50 6c             	lea    0x6c(%eax),%edx
80103d5d:	ff 70 0c             	pushl  0xc(%eax)
80103d60:	52                   	push   %edx
80103d61:	ff 70 10             	pushl  0x10(%eax)
80103d64:	68 79 88 10 80       	push   $0x80108879
80103d69:	e8 f2 c8 ff ff       	call   80100660 <cprintf>
  for(int i=0; i<=c0; i++)
80103d6e:	83 c4 10             	add    $0x10,%esp
80103d71:	39 1d 2c c0 10 80    	cmp    %ebx,0x8010c02c
80103d77:	7d d7                	jge    80103d50 <display_queues+0x200>
  cprintf("\n");
80103d79:	83 ec 0c             	sub    $0xc,%esp
80103d7c:	68 37 90 10 80       	push   $0x80109037
80103d81:	e8 da c8 ff ff       	call   80100660 <cprintf>
80103d86:	83 c4 10             	add    $0x10,%esp
80103d89:	e9 e3 fd ff ff       	jmp    80103b71 <display_queues+0x21>
80103d8e:	66 90                	xchg   %ax,%ax

80103d90 <userinit>:
{
80103d90:	55                   	push   %ebp
80103d91:	89 e5                	mov    %esp,%ebp
80103d93:	53                   	push   %ebx
80103d94:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103d97:	e8 64 f8 ff ff       	call   80103600 <allocproc>
80103d9c:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103d9e:	a3 d8 c5 10 80       	mov    %eax,0x8010c5d8
  if ((p->pgdir = setupkvm()) == 0)
80103da3:	e8 b8 42 00 00       	call   80108060 <setupkvm>
80103da8:	85 c0                	test   %eax,%eax
80103daa:	89 43 04             	mov    %eax,0x4(%ebx)
80103dad:	0f 84 bd 00 00 00    	je     80103e70 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103db3:	83 ec 04             	sub    $0x4,%esp
80103db6:	68 2c 00 00 00       	push   $0x2c
80103dbb:	68 80 c4 10 80       	push   $0x8010c480
80103dc0:	50                   	push   %eax
80103dc1:	e8 7a 3f 00 00       	call   80107d40 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103dc6:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103dc9:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103dcf:	6a 4c                	push   $0x4c
80103dd1:	6a 00                	push   $0x0
80103dd3:	ff 73 18             	pushl  0x18(%ebx)
80103dd6:	e8 45 19 00 00       	call   80105720 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103ddb:	8b 43 18             	mov    0x18(%ebx),%eax
80103dde:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103de3:	b9 23 00 00 00       	mov    $0x23,%ecx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103de8:	83 c4 0c             	add    $0xc,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103deb:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103def:	8b 43 18             	mov    0x18(%ebx),%eax
80103df2:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103df6:	8b 43 18             	mov    0x18(%ebx),%eax
80103df9:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103dfd:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103e01:	8b 43 18             	mov    0x18(%ebx),%eax
80103e04:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103e08:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103e0c:	8b 43 18             	mov    0x18(%ebx),%eax
80103e0f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103e16:	8b 43 18             	mov    0x18(%ebx),%eax
80103e19:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0; // beginning of initcode.S
80103e20:	8b 43 18             	mov    0x18(%ebx),%eax
80103e23:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103e2a:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103e2d:	6a 10                	push   $0x10
80103e2f:	68 d2 88 10 80       	push   $0x801088d2
80103e34:	50                   	push   %eax
80103e35:	e8 c6 1a 00 00       	call   80105900 <safestrcpy>
  p->cwd = namei("/");
80103e3a:	c7 04 24 db 88 10 80 	movl   $0x801088db,(%esp)
80103e41:	e8 9a e0 ff ff       	call   80101ee0 <namei>
80103e46:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103e49:	c7 04 24 40 51 11 80 	movl   $0x80115140,(%esp)
80103e50:	e8 bb 17 00 00       	call   80105610 <acquire>
  p->state = RUNNABLE;
80103e55:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103e5c:	c7 04 24 40 51 11 80 	movl   $0x80115140,(%esp)
80103e63:	e8 68 18 00 00       	call   801056d0 <release>
}
80103e68:	83 c4 10             	add    $0x10,%esp
80103e6b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103e6e:	c9                   	leave  
80103e6f:	c3                   	ret    
    panic("userinit: out of memory?");
80103e70:	83 ec 0c             	sub    $0xc,%esp
80103e73:	68 b9 88 10 80       	push   $0x801088b9
80103e78:	e8 13 c5 ff ff       	call   80100390 <panic>
80103e7d:	8d 76 00             	lea    0x0(%esi),%esi

80103e80 <growproc>:
{
80103e80:	55                   	push   %ebp
80103e81:	89 e5                	mov    %esp,%ebp
80103e83:	56                   	push   %esi
80103e84:	53                   	push   %ebx
80103e85:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103e88:	e8 b3 16 00 00       	call   80105540 <pushcli>
  c = mycpu();
80103e8d:	e8 6e f9 ff ff       	call   80103800 <mycpu>
  p = c->proc;
80103e92:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103e98:	e8 e3 16 00 00       	call   80105580 <popcli>
  if (n > 0)
80103e9d:	83 fe 00             	cmp    $0x0,%esi
  sz = curproc->sz;
80103ea0:	8b 03                	mov    (%ebx),%eax
  if (n > 0)
80103ea2:	7f 1c                	jg     80103ec0 <growproc+0x40>
  else if (n < 0)
80103ea4:	75 3a                	jne    80103ee0 <growproc+0x60>
  switchuvm(curproc);
80103ea6:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103ea9:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103eab:	53                   	push   %ebx
80103eac:	e8 7f 3d 00 00       	call   80107c30 <switchuvm>
  return 0;
80103eb1:	83 c4 10             	add    $0x10,%esp
80103eb4:	31 c0                	xor    %eax,%eax
}
80103eb6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103eb9:	5b                   	pop    %ebx
80103eba:	5e                   	pop    %esi
80103ebb:	5d                   	pop    %ebp
80103ebc:	c3                   	ret    
80103ebd:	8d 76 00             	lea    0x0(%esi),%esi
    if ((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103ec0:	83 ec 04             	sub    $0x4,%esp
80103ec3:	01 c6                	add    %eax,%esi
80103ec5:	56                   	push   %esi
80103ec6:	50                   	push   %eax
80103ec7:	ff 73 04             	pushl  0x4(%ebx)
80103eca:	e8 b1 3f 00 00       	call   80107e80 <allocuvm>
80103ecf:	83 c4 10             	add    $0x10,%esp
80103ed2:	85 c0                	test   %eax,%eax
80103ed4:	75 d0                	jne    80103ea6 <growproc+0x26>
      return -1;
80103ed6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103edb:	eb d9                	jmp    80103eb6 <growproc+0x36>
80103edd:	8d 76 00             	lea    0x0(%esi),%esi
    if ((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103ee0:	83 ec 04             	sub    $0x4,%esp
80103ee3:	01 c6                	add    %eax,%esi
80103ee5:	56                   	push   %esi
80103ee6:	50                   	push   %eax
80103ee7:	ff 73 04             	pushl  0x4(%ebx)
80103eea:	e8 c1 40 00 00       	call   80107fb0 <deallocuvm>
80103eef:	83 c4 10             	add    $0x10,%esp
80103ef2:	85 c0                	test   %eax,%eax
80103ef4:	75 b0                	jne    80103ea6 <growproc+0x26>
80103ef6:	eb de                	jmp    80103ed6 <growproc+0x56>
80103ef8:	90                   	nop
80103ef9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103f00 <fork>:
{
80103f00:	55                   	push   %ebp
80103f01:	89 e5                	mov    %esp,%ebp
80103f03:	57                   	push   %edi
80103f04:	56                   	push   %esi
80103f05:	53                   	push   %ebx
80103f06:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103f09:	e8 32 16 00 00       	call   80105540 <pushcli>
  c = mycpu();
80103f0e:	e8 ed f8 ff ff       	call   80103800 <mycpu>
  p = c->proc;
80103f13:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103f19:	e8 62 16 00 00       	call   80105580 <popcli>
  if ((np = allocproc()) == 0)
80103f1e:	e8 dd f6 ff ff       	call   80103600 <allocproc>
80103f23:	85 c0                	test   %eax,%eax
80103f25:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103f28:	0f 84 b7 00 00 00    	je     80103fe5 <fork+0xe5>
  if ((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0)
80103f2e:	83 ec 08             	sub    $0x8,%esp
80103f31:	ff 33                	pushl  (%ebx)
80103f33:	ff 73 04             	pushl  0x4(%ebx)
80103f36:	89 c7                	mov    %eax,%edi
80103f38:	e8 f3 41 00 00       	call   80108130 <copyuvm>
80103f3d:	83 c4 10             	add    $0x10,%esp
80103f40:	85 c0                	test   %eax,%eax
80103f42:	89 47 04             	mov    %eax,0x4(%edi)
80103f45:	0f 84 a1 00 00 00    	je     80103fec <fork+0xec>
  np->sz = curproc->sz;
80103f4b:	8b 03                	mov    (%ebx),%eax
80103f4d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103f50:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
80103f52:	89 59 14             	mov    %ebx,0x14(%ecx)
80103f55:	89 c8                	mov    %ecx,%eax
  *np->tf = *curproc->tf;
80103f57:	8b 79 18             	mov    0x18(%ecx),%edi
80103f5a:	8b 73 18             	mov    0x18(%ebx),%esi
80103f5d:	b9 13 00 00 00       	mov    $0x13,%ecx
80103f62:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for (i = 0; i < NOFILE; i++)
80103f64:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103f66:	8b 40 18             	mov    0x18(%eax),%eax
80103f69:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if (curproc->ofile[i])
80103f70:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103f74:	85 c0                	test   %eax,%eax
80103f76:	74 13                	je     80103f8b <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103f78:	83 ec 0c             	sub    $0xc,%esp
80103f7b:	50                   	push   %eax
80103f7c:	e8 6f ce ff ff       	call   80100df0 <filedup>
80103f81:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103f84:	83 c4 10             	add    $0x10,%esp
80103f87:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for (i = 0; i < NOFILE; i++)
80103f8b:	83 c6 01             	add    $0x1,%esi
80103f8e:	83 fe 10             	cmp    $0x10,%esi
80103f91:	75 dd                	jne    80103f70 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103f93:	83 ec 0c             	sub    $0xc,%esp
80103f96:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103f99:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103f9c:	e8 af d6 ff ff       	call   80101650 <idup>
80103fa1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103fa4:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103fa7:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103faa:	8d 47 6c             	lea    0x6c(%edi),%eax
80103fad:	6a 10                	push   $0x10
80103faf:	53                   	push   %ebx
80103fb0:	50                   	push   %eax
80103fb1:	e8 4a 19 00 00       	call   80105900 <safestrcpy>
  pid = np->pid;
80103fb6:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103fb9:	c7 04 24 40 51 11 80 	movl   $0x80115140,(%esp)
80103fc0:	e8 4b 16 00 00       	call   80105610 <acquire>
  np->state = RUNNABLE;
80103fc5:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103fcc:	c7 04 24 40 51 11 80 	movl   $0x80115140,(%esp)
80103fd3:	e8 f8 16 00 00       	call   801056d0 <release>
  return pid;
80103fd8:	83 c4 10             	add    $0x10,%esp
}
80103fdb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103fde:	89 d8                	mov    %ebx,%eax
80103fe0:	5b                   	pop    %ebx
80103fe1:	5e                   	pop    %esi
80103fe2:	5f                   	pop    %edi
80103fe3:	5d                   	pop    %ebp
80103fe4:	c3                   	ret    
    return -1;
80103fe5:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103fea:	eb ef                	jmp    80103fdb <fork+0xdb>
    kfree(np->kstack);
80103fec:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103fef:	83 ec 0c             	sub    $0xc,%esp
80103ff2:	ff 73 08             	pushl  0x8(%ebx)
80103ff5:	e8 16 e3 ff ff       	call   80102310 <kfree>
    np->kstack = 0;
80103ffa:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    np->state = UNUSED;
80104001:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80104008:	83 c4 10             	add    $0x10,%esp
8010400b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104010:	eb c9                	jmp    80103fdb <fork+0xdb>
80104012:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104019:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104020 <ageing>:
{
80104020:	55                   	push   %ebp
80104021:	89 e5                	mov    %esp,%ebp
80104023:	53                   	push   %ebx
80104024:	83 ec 04             	sub    $0x4,%esp
  for(int i=0; i<=c1; i++)
80104027:	8b 1d 28 c0 10 80    	mov    0x8010c028,%ebx
8010402d:	85 db                	test   %ebx,%ebx
8010402f:	0f 88 cb 00 00 00    	js     80104100 <ageing+0xe0>
80104035:	31 db                	xor    %ebx,%ebx
80104037:	eb 16                	jmp    8010404f <ageing+0x2f>
80104039:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104040:	83 c3 01             	add    $0x1,%ebx
80104043:	39 1d 28 c0 10 80    	cmp    %ebx,0x8010c028
80104049:	0f 8c b1 00 00 00    	jl     80104100 <ageing+0xe0>
    if(q1[i]->state!=RUNNABLE)
8010404f:	8b 04 9d 40 4f 11 80 	mov    -0x7feeb0c0(,%ebx,4),%eax
80104056:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
8010405a:	75 e4                	jne    80104040 <ageing+0x20>
    if(ticks-q1[i]->start > q1[i]->waittime)
8010405c:	8b 15 c0 89 11 80    	mov    0x801189c0,%edx
80104062:	2b 90 b0 00 00 00    	sub    0xb0(%eax),%edx
80104068:	8b 88 b4 00 00 00    	mov    0xb4(%eax),%ecx
8010406e:	39 ca                	cmp    %ecx,%edx
80104070:	76 ce                	jbe    80104040 <ageing+0x20>
      cprintf("\033[1;32m %d switching to queue 0  since waittime %ds exceeded\n\033[0m", q1[i]->pid, q1[i]->waittime);
80104072:	83 ec 04             	sub    $0x4,%esp
80104075:	51                   	push   %ecx
80104076:	ff 70 10             	pushl  0x10(%eax)
80104079:	68 0c 8a 10 80       	push   $0x80108a0c
8010407e:	e8 dd c5 ff ff       	call   80100660 <cprintf>
      q1[i]->current_queue--;
80104083:	8b 14 9d 40 4f 11 80 	mov    -0x7feeb0c0(,%ebx,4),%edx
      c0++;
8010408a:	a1 2c c0 10 80       	mov    0x8010c02c,%eax
      q1[i]->current_queue--;
8010408f:	83 aa b8 00 00 00 01 	subl   $0x1,0xb8(%edx)
      c0++;
80104096:	83 c0 01             	add    $0x1,%eax
      q1[i]->ticks[q1[i]->current_queue]=0;
80104099:	8b 14 9d 40 4f 11 80 	mov    -0x7feeb0c0(,%ebx,4),%edx
      c0++;
801040a0:	a3 2c c0 10 80       	mov    %eax,0x8010c02c
      q1[i]->ticks[q1[i]->current_queue]=0;
801040a5:	8b 8a b8 00 00 00    	mov    0xb8(%edx),%ecx
801040ab:	c7 84 8a 94 00 00 00 	movl   $0x0,0x94(%edx,%ecx,4)
801040b2:	00 00 00 00 
      q1[i]->start=ticks;
801040b6:	8b 0d c0 89 11 80    	mov    0x801189c0,%ecx
801040bc:	8b 14 9d 40 4f 11 80 	mov    -0x7feeb0c0(,%ebx,4),%edx
801040c3:	89 8a b0 00 00 00    	mov    %ecx,0xb0(%edx)
      q0[c0] = q1[i];
801040c9:	8b 14 9d 40 4f 11 80 	mov    -0x7feeb0c0(,%ebx,4),%edx
  for(int i=0; i<=c1; i++)
801040d0:	83 c3 01             	add    $0x1,%ebx
      q0[c0] = q1[i];
801040d3:	89 14 85 40 50 11 80 	mov    %edx,-0x7feeafc0(,%eax,4)
      rem_process(q1[i]->pid, q1[i]->current_queue);
801040da:	58                   	pop    %eax
801040db:	59                   	pop    %ecx
801040dc:	ff b2 b8 00 00 00    	pushl  0xb8(%edx)
801040e2:	ff 72 10             	pushl  0x10(%edx)
801040e5:	e8 e6 f7 ff ff       	call   801038d0 <rem_process>
801040ea:	83 c4 10             	add    $0x10,%esp
  for(int i=0; i<=c1; i++)
801040ed:	39 1d 28 c0 10 80    	cmp    %ebx,0x8010c028
801040f3:	0f 8d 56 ff ff ff    	jge    8010404f <ageing+0x2f>
801040f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(int i=0; i<=c2; i++)
80104100:	8b 1d 24 c0 10 80    	mov    0x8010c024,%ebx
80104106:	85 db                	test   %ebx,%ebx
80104108:	0f 88 d2 00 00 00    	js     801041e0 <ageing+0x1c0>
8010410e:	31 db                	xor    %ebx,%ebx
80104110:	eb 15                	jmp    80104127 <ageing+0x107>
80104112:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104118:	83 c3 01             	add    $0x1,%ebx
8010411b:	39 1d 24 c0 10 80    	cmp    %ebx,0x8010c024
80104121:	0f 8c b9 00 00 00    	jl     801041e0 <ageing+0x1c0>
    if(q1[i]->state!=RUNNABLE)
80104127:	8b 04 9d 40 4f 11 80 	mov    -0x7feeb0c0(,%ebx,4),%eax
8010412e:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80104132:	75 e4                	jne    80104118 <ageing+0xf8>
    if(ticks-q2[i]->start > q2[i]->waittime)
80104134:	8b 14 9d 40 4d 11 80 	mov    -0x7feeb2c0(,%ebx,4),%edx
8010413b:	a1 c0 89 11 80       	mov    0x801189c0,%eax
80104140:	2b 82 b0 00 00 00    	sub    0xb0(%edx),%eax
80104146:	8b 8a b4 00 00 00    	mov    0xb4(%edx),%ecx
8010414c:	39 c8                	cmp    %ecx,%eax
8010414e:	76 c8                	jbe    80104118 <ageing+0xf8>
      cprintf("\033[1;32m %d switching to queue 1  since waittime %ds exceeded\n\033[0m", q2[i]->pid, q2[i]->waittime);
80104150:	83 ec 04             	sub    $0x4,%esp
80104153:	51                   	push   %ecx
80104154:	ff 72 10             	pushl  0x10(%edx)
80104157:	68 50 8a 10 80       	push   $0x80108a50
8010415c:	e8 ff c4 ff ff       	call   80100660 <cprintf>
      q2[i]->current_queue--;
80104161:	8b 14 9d 40 4d 11 80 	mov    -0x7feeb2c0(,%ebx,4),%edx
      c1++;
80104168:	a1 28 c0 10 80       	mov    0x8010c028,%eax
      q2[i]->current_queue--;
8010416d:	83 aa b8 00 00 00 01 	subl   $0x1,0xb8(%edx)
      c1++;
80104174:	83 c0 01             	add    $0x1,%eax
      q2[i]->ticks[q2[i]->current_queue]=0;
80104177:	8b 14 9d 40 4d 11 80 	mov    -0x7feeb2c0(,%ebx,4),%edx
      c1++;
8010417e:	a3 28 c0 10 80       	mov    %eax,0x8010c028
      q2[i]->ticks[q2[i]->current_queue]=0;
80104183:	8b 8a b8 00 00 00    	mov    0xb8(%edx),%ecx
80104189:	c7 84 8a 94 00 00 00 	movl   $0x0,0x94(%edx,%ecx,4)
80104190:	00 00 00 00 
      q2[i]->start=ticks;
80104194:	8b 0d c0 89 11 80    	mov    0x801189c0,%ecx
8010419a:	8b 14 9d 40 4d 11 80 	mov    -0x7feeb2c0(,%ebx,4),%edx
801041a1:	89 8a b0 00 00 00    	mov    %ecx,0xb0(%edx)
      q1[c1] = q2[i];
801041a7:	8b 14 9d 40 4d 11 80 	mov    -0x7feeb2c0(,%ebx,4),%edx
  for(int i=0; i<=c2; i++)
801041ae:	83 c3 01             	add    $0x1,%ebx
      q1[c1] = q2[i];
801041b1:	89 14 85 40 4f 11 80 	mov    %edx,-0x7feeb0c0(,%eax,4)
      rem_process(q2[i]->pid, q2[i]->current_queue);
801041b8:	58                   	pop    %eax
801041b9:	59                   	pop    %ecx
801041ba:	ff b2 b8 00 00 00    	pushl  0xb8(%edx)
801041c0:	ff 72 10             	pushl  0x10(%edx)
801041c3:	e8 08 f7 ff ff       	call   801038d0 <rem_process>
801041c8:	83 c4 10             	add    $0x10,%esp
  for(int i=0; i<=c2; i++)
801041cb:	39 1d 24 c0 10 80    	cmp    %ebx,0x8010c024
801041d1:	0f 8d 50 ff ff ff    	jge    80104127 <ageing+0x107>
801041d7:	89 f6                	mov    %esi,%esi
801041d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  for(int i=0; i<=c3; i++)
801041e0:	8b 1d 20 c0 10 80    	mov    0x8010c020,%ebx
801041e6:	85 db                	test   %ebx,%ebx
801041e8:	0f 88 d2 00 00 00    	js     801042c0 <ageing+0x2a0>
801041ee:	31 db                	xor    %ebx,%ebx
801041f0:	eb 15                	jmp    80104207 <ageing+0x1e7>
801041f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801041f8:	83 c3 01             	add    $0x1,%ebx
801041fb:	39 1d 20 c0 10 80    	cmp    %ebx,0x8010c020
80104201:	0f 8c b9 00 00 00    	jl     801042c0 <ageing+0x2a0>
    if(q1[i]->state!=RUNNABLE)
80104207:	8b 04 9d 40 4f 11 80 	mov    -0x7feeb0c0(,%ebx,4),%eax
8010420e:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80104212:	75 e4                	jne    801041f8 <ageing+0x1d8>
    if(ticks-q3[i]->start > q3[i]->waittime)
80104214:	8b 14 9d 40 4e 11 80 	mov    -0x7feeb1c0(,%ebx,4),%edx
8010421b:	a1 c0 89 11 80       	mov    0x801189c0,%eax
80104220:	2b 82 b0 00 00 00    	sub    0xb0(%edx),%eax
80104226:	8b 8a b4 00 00 00    	mov    0xb4(%edx),%ecx
8010422c:	39 c8                	cmp    %ecx,%eax
8010422e:	76 c8                	jbe    801041f8 <ageing+0x1d8>
      cprintf("\033[1;32m %d switching to queue 2  since waittime %ds exceeded\n\033[0m", q3[i]->pid, q3[i]->waittime);
80104230:	83 ec 04             	sub    $0x4,%esp
80104233:	51                   	push   %ecx
80104234:	ff 72 10             	pushl  0x10(%edx)
80104237:	68 94 8a 10 80       	push   $0x80108a94
8010423c:	e8 1f c4 ff ff       	call   80100660 <cprintf>
      q3[i]->current_queue--;
80104241:	8b 14 9d 40 4e 11 80 	mov    -0x7feeb1c0(,%ebx,4),%edx
      c2++;
80104248:	a1 24 c0 10 80       	mov    0x8010c024,%eax
      q3[i]->current_queue--;
8010424d:	83 aa b8 00 00 00 01 	subl   $0x1,0xb8(%edx)
      c2++;
80104254:	83 c0 01             	add    $0x1,%eax
      q3[i]->ticks[q3[i]->current_queue]=0;
80104257:	8b 14 9d 40 4e 11 80 	mov    -0x7feeb1c0(,%ebx,4),%edx
      c2++;
8010425e:	a3 24 c0 10 80       	mov    %eax,0x8010c024
      q3[i]->ticks[q3[i]->current_queue]=0;
80104263:	8b 8a b8 00 00 00    	mov    0xb8(%edx),%ecx
80104269:	c7 84 8a 94 00 00 00 	movl   $0x0,0x94(%edx,%ecx,4)
80104270:	00 00 00 00 
      q3[i]->start=ticks;
80104274:	8b 0d c0 89 11 80    	mov    0x801189c0,%ecx
8010427a:	8b 14 9d 40 4e 11 80 	mov    -0x7feeb1c0(,%ebx,4),%edx
80104281:	89 8a b0 00 00 00    	mov    %ecx,0xb0(%edx)
      q2[c2] = q3[i];
80104287:	8b 14 9d 40 4e 11 80 	mov    -0x7feeb1c0(,%ebx,4),%edx
  for(int i=0; i<=c3; i++)
8010428e:	83 c3 01             	add    $0x1,%ebx
      q2[c2] = q3[i];
80104291:	89 14 85 40 4d 11 80 	mov    %edx,-0x7feeb2c0(,%eax,4)
      rem_process(q3[i]->pid, q3[i]->current_queue);
80104298:	58                   	pop    %eax
80104299:	59                   	pop    %ecx
8010429a:	ff b2 b8 00 00 00    	pushl  0xb8(%edx)
801042a0:	ff 72 10             	pushl  0x10(%edx)
801042a3:	e8 28 f6 ff ff       	call   801038d0 <rem_process>
801042a8:	83 c4 10             	add    $0x10,%esp
  for(int i=0; i<=c3; i++)
801042ab:	39 1d 20 c0 10 80    	cmp    %ebx,0x8010c020
801042b1:	0f 8d 50 ff ff ff    	jge    80104207 <ageing+0x1e7>
801042b7:	89 f6                	mov    %esi,%esi
801042b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  for(int i=0; i<=c4; i++)
801042c0:	8b 1d 1c c0 10 80    	mov    0x8010c01c,%ebx
801042c6:	85 db                	test   %ebx,%ebx
801042c8:	0f 88 c9 00 00 00    	js     80104397 <ageing+0x377>
801042ce:	31 db                	xor    %ebx,%ebx
801042d0:	eb 15                	jmp    801042e7 <ageing+0x2c7>
801042d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801042d8:	83 c3 01             	add    $0x1,%ebx
801042db:	39 1d 1c c0 10 80    	cmp    %ebx,0x8010c01c
801042e1:	0f 8c b0 00 00 00    	jl     80104397 <ageing+0x377>
    if(q1[i]->state!=RUNNABLE)
801042e7:	8b 04 9d 40 4f 11 80 	mov    -0x7feeb0c0(,%ebx,4),%eax
801042ee:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
801042f2:	75 e4                	jne    801042d8 <ageing+0x2b8>
    if(ticks-q4[i]->start > q4[i]->waittime)
801042f4:	8b 14 9d 80 80 11 80 	mov    -0x7fee7f80(,%ebx,4),%edx
801042fb:	a1 c0 89 11 80       	mov    0x801189c0,%eax
80104300:	2b 82 b0 00 00 00    	sub    0xb0(%edx),%eax
80104306:	8b 8a b4 00 00 00    	mov    0xb4(%edx),%ecx
8010430c:	39 c8                	cmp    %ecx,%eax
8010430e:	76 c8                	jbe    801042d8 <ageing+0x2b8>
      cprintf("\033[1;32m %d switching to queue 3  since waittime %ds exceeded\n\033[0m", q4[i]->pid, q4[i]->waittime);
80104310:	83 ec 04             	sub    $0x4,%esp
80104313:	51                   	push   %ecx
80104314:	ff 72 10             	pushl  0x10(%edx)
80104317:	68 d8 8a 10 80       	push   $0x80108ad8
8010431c:	e8 3f c3 ff ff       	call   80100660 <cprintf>
      q4[i]->current_queue--;
80104321:	8b 14 9d 80 80 11 80 	mov    -0x7fee7f80(,%ebx,4),%edx
      c3++;
80104328:	a1 20 c0 10 80       	mov    0x8010c020,%eax
      q4[i]->current_queue--;
8010432d:	83 aa b8 00 00 00 01 	subl   $0x1,0xb8(%edx)
      c3++;
80104334:	83 c0 01             	add    $0x1,%eax
      q4[i]->ticks[q4[i]->current_queue]=0;
80104337:	8b 14 9d 80 80 11 80 	mov    -0x7fee7f80(,%ebx,4),%edx
      c3++;
8010433e:	a3 20 c0 10 80       	mov    %eax,0x8010c020
      q4[i]->ticks[q4[i]->current_queue]=0;
80104343:	8b 8a b8 00 00 00    	mov    0xb8(%edx),%ecx
80104349:	c7 84 8a 94 00 00 00 	movl   $0x0,0x94(%edx,%ecx,4)
80104350:	00 00 00 00 
      q4[i]->start=ticks;
80104354:	8b 0d c0 89 11 80    	mov    0x801189c0,%ecx
8010435a:	8b 14 9d 80 80 11 80 	mov    -0x7fee7f80(,%ebx,4),%edx
80104361:	89 8a b0 00 00 00    	mov    %ecx,0xb0(%edx)
      q3[c3] = q4[i];
80104367:	8b 14 9d 80 80 11 80 	mov    -0x7fee7f80(,%ebx,4),%edx
  for(int i=0; i<=c4; i++)
8010436e:	83 c3 01             	add    $0x1,%ebx
      q3[c3] = q4[i];
80104371:	89 14 85 40 4e 11 80 	mov    %edx,-0x7feeb1c0(,%eax,4)
      rem_process(q4[i]->pid, q4[i]->current_queue);
80104378:	58                   	pop    %eax
80104379:	59                   	pop    %ecx
8010437a:	ff b2 b8 00 00 00    	pushl  0xb8(%edx)
80104380:	ff 72 10             	pushl  0x10(%edx)
80104383:	e8 48 f5 ff ff       	call   801038d0 <rem_process>
80104388:	83 c4 10             	add    $0x10,%esp
  for(int i=0; i<=c4; i++)
8010438b:	39 1d 1c c0 10 80    	cmp    %ebx,0x8010c01c
80104391:	0f 8d 50 ff ff ff    	jge    801042e7 <ageing+0x2c7>
}
80104397:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010439a:	c9                   	leave  
8010439b:	c3                   	ret    
8010439c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801043a0 <scheduler>:
{
801043a0:	55                   	push   %ebp
801043a1:	89 e5                	mov    %esp,%ebp
801043a3:	57                   	push   %edi
801043a4:	56                   	push   %esi
801043a5:	53                   	push   %ebx
801043a6:	83 ec 1c             	sub    $0x1c,%esp
  struct cpu *c = mycpu();
801043a9:	e8 52 f4 ff ff       	call   80103800 <mycpu>
  c->proc = 0;
801043ae:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
801043b5:	00 00 00 
  struct cpu *c = mycpu();
801043b8:	89 c3                	mov    %eax,%ebx
801043ba:	8d 40 04             	lea    0x4(%eax),%eax
801043bd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  asm volatile("sti");
801043c0:	fb                   	sti    
    acquire(&ptable.lock);
801043c1:	83 ec 0c             	sub    $0xc,%esp
801043c4:	68 40 51 11 80       	push   $0x80115140
801043c9:	e8 42 12 00 00       	call   80105610 <acquire>
    ageing();
801043ce:	e8 4d fc ff ff       	call   80104020 <ageing>
    if (c0 != -1) // ENTERING QUEUE 0
801043d3:	8b 0d 2c c0 10 80    	mov    0x8010c02c,%ecx
801043d9:	83 c4 10             	add    $0x10,%esp
801043dc:	85 c9                	test   %ecx,%ecx
801043de:	0f 88 ec 00 00 00    	js     801044d0 <scheduler+0x130>
      for (i = 0; i <= c0; i++)
801043e4:	31 f6                	xor    %esi,%esi
801043e6:	eb 18                	jmp    80104400 <scheduler+0x60>
801043e8:	90                   	nop
801043e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801043f0:	a1 2c c0 10 80       	mov    0x8010c02c,%eax
801043f5:	83 c6 01             	add    $0x1,%esi
801043f8:	39 c6                	cmp    %eax,%esi
801043fa:	0f 8f d0 00 00 00    	jg     801044d0 <scheduler+0x130>
        if (q0[i]->state != RUNNABLE)
80104400:	8b 04 b5 40 50 11 80 	mov    -0x7feeafc0(,%esi,4),%eax
80104407:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
8010440b:	75 e3                	jne    801043f0 <scheduler+0x50>
        q0[i]->start=ticks;
8010440d:	8b 15 c0 89 11 80    	mov    0x801189c0,%edx
80104413:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
        m_proc = q0[i];
80104419:	8b 3c b5 40 50 11 80 	mov    -0x7feeafc0(,%esi,4),%edi
        display_queues();
80104420:	e8 2b f7 ff ff       	call   80103b50 <display_queues>
        switchuvm(m_proc);
80104425:	83 ec 0c             	sub    $0xc,%esp
        c->proc = m_proc;
80104428:	89 bb ac 00 00 00    	mov    %edi,0xac(%ebx)
        switchuvm(m_proc);
8010442e:	57                   	push   %edi
8010442f:	e8 fc 37 00 00       	call   80107c30 <switchuvm>
        m_proc->num_run++;
80104434:	83 87 8c 00 00 00 01 	addl   $0x1,0x8c(%edi)
        m_proc->state = RUNNING;
8010443b:	c7 47 0c 04 00 00 00 	movl   $0x4,0xc(%edi)
        swtch((&c->scheduler), m_proc->context);
80104442:	58                   	pop    %eax
80104443:	5a                   	pop    %edx
80104444:	ff 77 1c             	pushl  0x1c(%edi)
80104447:	ff 75 e4             	pushl  -0x1c(%ebp)
8010444a:	e8 0c 15 00 00       	call   8010595b <swtch>
        switchkvm();
8010444f:	e8 bc 37 00 00       	call   80107c10 <switchkvm>
        c->proc = 0;
80104454:	c7 83 ac 00 00 00 00 	movl   $0x0,0xac(%ebx)
8010445b:	00 00 00 
        if ((m_proc->ticks[0] >= clockperiod[0]) && m_proc->pid > 3)
8010445e:	83 c4 10             	add    $0x10,%esp
80104461:	8b 87 94 00 00 00    	mov    0x94(%edi),%eax
80104467:	3b 05 08 c0 10 80    	cmp    0x8010c008,%eax
8010446d:	7c 81                	jl     801043f0 <scheduler+0x50>
8010446f:	8b 57 10             	mov    0x10(%edi),%edx
80104472:	83 fa 03             	cmp    $0x3,%edx
80104475:	0f 8e 75 ff ff ff    	jle    801043f0 <scheduler+0x50>
          if (m_proc->killed == 0)
8010447b:	8b 4f 24             	mov    0x24(%edi),%ecx
8010447e:	85 c9                	test   %ecx,%ecx
80104480:	0f 84 82 05 00 00    	je     80104a08 <scheduler+0x668>
          for (j = i; j <= c0 - 1; j++)
80104486:	a1 2c c0 10 80       	mov    0x8010c02c,%eax
8010448b:	39 c6                	cmp    %eax,%esi
8010448d:	7d 21                	jge    801044b0 <scheduler+0x110>
8010448f:	8d 14 b5 40 50 11 80 	lea    -0x7feeafc0(,%esi,4),%edx
80104496:	8d 0c 85 40 50 11 80 	lea    -0x7feeafc0(,%eax,4),%ecx
8010449d:	89 45 e0             	mov    %eax,-0x20(%ebp)
            q0[j] = q0[j + 1];
801044a0:	8b 42 04             	mov    0x4(%edx),%eax
801044a3:	83 c2 04             	add    $0x4,%edx
801044a6:	89 42 fc             	mov    %eax,-0x4(%edx)
          for (j = i; j <= c0 - 1; j++)
801044a9:	39 ca                	cmp    %ecx,%edx
801044ab:	75 f3                	jne    801044a0 <scheduler+0x100>
801044ad:	8b 45 e0             	mov    -0x20(%ebp),%eax
          c0--;
801044b0:	83 e8 01             	sub    $0x1,%eax
      for (i = 0; i <= c0; i++)
801044b3:	83 c6 01             	add    $0x1,%esi
          m_proc->ticks[0] = 0;
801044b6:	c7 87 94 00 00 00 00 	movl   $0x0,0x94(%edi)
801044bd:	00 00 00 
      for (i = 0; i <= c0; i++)
801044c0:	39 c6                	cmp    %eax,%esi
          c0--;
801044c2:	a3 2c c0 10 80       	mov    %eax,0x8010c02c
      for (i = 0; i <= c0; i++)
801044c7:	0f 8e 33 ff ff ff    	jle    80104400 <scheduler+0x60>
801044cd:	8d 76 00             	lea    0x0(%esi),%esi
    if (c1 != -1) //ENTERING QUEUE 1
801044d0:	8b 0d 28 c0 10 80    	mov    0x8010c028,%ecx
801044d6:	85 c9                	test   %ecx,%ecx
801044d8:	0f 88 f2 00 00 00    	js     801045d0 <scheduler+0x230>
      for (i = 0; i <= c1; i++)
801044de:	31 f6                	xor    %esi,%esi
801044e0:	eb 11                	jmp    801044f3 <scheduler+0x153>
801044e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801044e8:	83 c6 01             	add    $0x1,%esi
801044eb:	39 d6                	cmp    %edx,%esi
801044ed:	0f 8f dd 00 00 00    	jg     801045d0 <scheduler+0x230>
        if (q1[i]->state != RUNNABLE)
801044f3:	8b 04 b5 40 4f 11 80 	mov    -0x7feeb0c0(,%esi,4),%eax
801044fa:	8b 15 28 c0 10 80    	mov    0x8010c028,%edx
80104500:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80104504:	75 e2                	jne    801044e8 <scheduler+0x148>
        q1[i]->start=ticks;
80104506:	8b 15 c0 89 11 80    	mov    0x801189c0,%edx
8010450c:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
        m_proc = q1[i];
80104512:	8b 3c b5 40 4f 11 80 	mov    -0x7feeb0c0(,%esi,4),%edi
        display_queues();
80104519:	e8 32 f6 ff ff       	call   80103b50 <display_queues>
        switchuvm(m_proc);
8010451e:	83 ec 0c             	sub    $0xc,%esp
        c->proc = m_proc;
80104521:	89 bb ac 00 00 00    	mov    %edi,0xac(%ebx)
        switchuvm(m_proc);
80104527:	57                   	push   %edi
80104528:	e8 03 37 00 00       	call   80107c30 <switchuvm>
        m_proc->num_run++;
8010452d:	83 87 8c 00 00 00 01 	addl   $0x1,0x8c(%edi)
        m_proc->state = RUNNING;
80104534:	c7 47 0c 04 00 00 00 	movl   $0x4,0xc(%edi)
        swtch(&c->scheduler, m_proc->context);
8010453b:	58                   	pop    %eax
8010453c:	5a                   	pop    %edx
8010453d:	ff 77 1c             	pushl  0x1c(%edi)
80104540:	ff 75 e4             	pushl  -0x1c(%ebp)
80104543:	e8 13 14 00 00       	call   8010595b <swtch>
        switchkvm();
80104548:	e8 c3 36 00 00       	call   80107c10 <switchkvm>
        c->proc = 0;
8010454d:	c7 83 ac 00 00 00 00 	movl   $0x0,0xac(%ebx)
80104554:	00 00 00 
        if (m_proc->ticks[1] >= clockperiod[1] || m_proc->killed!=0)
80104557:	83 c4 10             	add    $0x10,%esp
8010455a:	8b 87 98 00 00 00    	mov    0x98(%edi),%eax
80104560:	3b 05 0c c0 10 80    	cmp    0x8010c00c,%eax
80104566:	0f 8d 24 04 00 00    	jge    80104990 <scheduler+0x5f0>
8010456c:	8b 4f 24             	mov    0x24(%edi),%ecx
8010456f:	8b 15 28 c0 10 80    	mov    0x8010c028,%edx
80104575:	85 c9                	test   %ecx,%ecx
80104577:	0f 84 6b ff ff ff    	je     801044e8 <scheduler+0x148>
          for (j = i; j <= c1 - 1; j++)
8010457d:	39 d6                	cmp    %edx,%esi
8010457f:	7d 27                	jge    801045a8 <scheduler+0x208>
80104581:	8d 04 b5 40 4f 11 80 	lea    -0x7feeb0c0(,%esi,4),%eax
80104588:	8d 0c 95 40 4f 11 80 	lea    -0x7feeb0c0(,%edx,4),%ecx
8010458f:	89 55 e0             	mov    %edx,-0x20(%ebp)
80104592:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            q1[j] = q1[j + 1];
80104598:	8b 50 04             	mov    0x4(%eax),%edx
8010459b:	83 c0 04             	add    $0x4,%eax
8010459e:	89 50 fc             	mov    %edx,-0x4(%eax)
          for (j = i; j <= c1 - 1; j++)
801045a1:	39 c8                	cmp    %ecx,%eax
801045a3:	75 f3                	jne    80104598 <scheduler+0x1f8>
801045a5:	8b 55 e0             	mov    -0x20(%ebp),%edx
          c1--;
801045a8:	83 ea 01             	sub    $0x1,%edx
      for (i = 0; i <= c1; i++)
801045ab:	83 c6 01             	add    $0x1,%esi
          m_proc->ticks[1] = 0;
801045ae:	c7 87 98 00 00 00 00 	movl   $0x0,0x98(%edi)
801045b5:	00 00 00 
      for (i = 0; i <= c1; i++)
801045b8:	39 d6                	cmp    %edx,%esi
          c1--;
801045ba:	89 15 28 c0 10 80    	mov    %edx,0x8010c028
      for (i = 0; i <= c1; i++)
801045c0:	0f 8e 2d ff ff ff    	jle    801044f3 <scheduler+0x153>
801045c6:	8d 76 00             	lea    0x0(%esi),%esi
801045c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if (c2 != -1)
801045d0:	8b 0d 24 c0 10 80    	mov    0x8010c024,%ecx
801045d6:	85 c9                	test   %ecx,%ecx
801045d8:	0f 88 f2 00 00 00    	js     801046d0 <scheduler+0x330>
      for (i = 0; i <= c2; i++)
801045de:	31 f6                	xor    %esi,%esi
801045e0:	eb 11                	jmp    801045f3 <scheduler+0x253>
801045e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801045e8:	83 c6 01             	add    $0x1,%esi
801045eb:	39 f2                	cmp    %esi,%edx
801045ed:	0f 8c dd 00 00 00    	jl     801046d0 <scheduler+0x330>
        if (q2[i]->state != RUNNABLE)
801045f3:	8b 04 b5 40 4d 11 80 	mov    -0x7feeb2c0(,%esi,4),%eax
801045fa:	8b 15 24 c0 10 80    	mov    0x8010c024,%edx
80104600:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80104604:	75 e2                	jne    801045e8 <scheduler+0x248>
        q2[i]->start=ticks;
80104606:	8b 15 c0 89 11 80    	mov    0x801189c0,%edx
8010460c:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
        m_proc = q2[i];
80104612:	8b 3c b5 40 4d 11 80 	mov    -0x7feeb2c0(,%esi,4),%edi
        display_queues();
80104619:	e8 32 f5 ff ff       	call   80103b50 <display_queues>
        switchuvm(m_proc);
8010461e:	83 ec 0c             	sub    $0xc,%esp
        c->proc = m_proc;
80104621:	89 bb ac 00 00 00    	mov    %edi,0xac(%ebx)
        switchuvm(m_proc);
80104627:	57                   	push   %edi
80104628:	e8 03 36 00 00       	call   80107c30 <switchuvm>
        m_proc->num_run++;
8010462d:	83 87 8c 00 00 00 01 	addl   $0x1,0x8c(%edi)
        m_proc->state = RUNNING;
80104634:	c7 47 0c 04 00 00 00 	movl   $0x4,0xc(%edi)
        swtch(&c->scheduler, m_proc->context);
8010463b:	58                   	pop    %eax
8010463c:	5a                   	pop    %edx
8010463d:	ff 77 1c             	pushl  0x1c(%edi)
80104640:	ff 75 e4             	pushl  -0x1c(%ebp)
80104643:	e8 13 13 00 00       	call   8010595b <swtch>
        switchkvm();
80104648:	e8 c3 35 00 00       	call   80107c10 <switchkvm>
        c->proc = 0;
8010464d:	c7 83 ac 00 00 00 00 	movl   $0x0,0xac(%ebx)
80104654:	00 00 00 
        if (m_proc->ticks[2] >= clockperiod[2]|| m_proc->killed!=0)
80104657:	83 c4 10             	add    $0x10,%esp
8010465a:	8b 87 9c 00 00 00    	mov    0x9c(%edi),%eax
80104660:	3b 05 10 c0 10 80    	cmp    0x8010c010,%eax
80104666:	0f 8d d4 02 00 00    	jge    80104940 <scheduler+0x5a0>
8010466c:	8b 4f 24             	mov    0x24(%edi),%ecx
8010466f:	8b 15 24 c0 10 80    	mov    0x8010c024,%edx
80104675:	85 c9                	test   %ecx,%ecx
80104677:	0f 84 6b ff ff ff    	je     801045e8 <scheduler+0x248>
          for (j = i; j <= c2 - 1; j++)
8010467d:	39 f2                	cmp    %esi,%edx
8010467f:	7e 27                	jle    801046a8 <scheduler+0x308>
80104681:	8d 04 b5 40 4d 11 80 	lea    -0x7feeb2c0(,%esi,4),%eax
80104688:	8d 0c 95 40 4d 11 80 	lea    -0x7feeb2c0(,%edx,4),%ecx
8010468f:	89 55 e0             	mov    %edx,-0x20(%ebp)
80104692:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            q2[j] = q2[j + 1];
80104698:	8b 50 04             	mov    0x4(%eax),%edx
8010469b:	83 c0 04             	add    $0x4,%eax
8010469e:	89 50 fc             	mov    %edx,-0x4(%eax)
          for (j = i; j <= c2 - 1; j++)
801046a1:	39 c8                	cmp    %ecx,%eax
801046a3:	75 f3                	jne    80104698 <scheduler+0x2f8>
801046a5:	8b 55 e0             	mov    -0x20(%ebp),%edx
          c2--;
801046a8:	83 ea 01             	sub    $0x1,%edx
      for (i = 0; i <= c2; i++)
801046ab:	83 c6 01             	add    $0x1,%esi
          m_proc->ticks[2] = 0;
801046ae:	c7 87 9c 00 00 00 00 	movl   $0x0,0x9c(%edi)
801046b5:	00 00 00 
      for (i = 0; i <= c2; i++)
801046b8:	39 f2                	cmp    %esi,%edx
          c2--;
801046ba:	89 15 24 c0 10 80    	mov    %edx,0x8010c024
      for (i = 0; i <= c2; i++)
801046c0:	0f 8d 2d ff ff ff    	jge    801045f3 <scheduler+0x253>
801046c6:	8d 76 00             	lea    0x0(%esi),%esi
801046c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if (c3 != -1)
801046d0:	8b 0d 20 c0 10 80    	mov    0x8010c020,%ecx
801046d6:	85 c9                	test   %ecx,%ecx
801046d8:	0f 88 f2 00 00 00    	js     801047d0 <scheduler+0x430>
      for (i = 0; i <= c3; i++)
801046de:	31 f6                	xor    %esi,%esi
801046e0:	eb 11                	jmp    801046f3 <scheduler+0x353>
801046e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801046e8:	83 c6 01             	add    $0x1,%esi
801046eb:	39 d6                	cmp    %edx,%esi
801046ed:	0f 8f dd 00 00 00    	jg     801047d0 <scheduler+0x430>
        if (q3[i]->state != RUNNABLE)
801046f3:	8b 04 b5 40 4e 11 80 	mov    -0x7feeb1c0(,%esi,4),%eax
801046fa:	8b 15 20 c0 10 80    	mov    0x8010c020,%edx
80104700:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80104704:	75 e2                	jne    801046e8 <scheduler+0x348>
        q3[i]->start=ticks;
80104706:	8b 15 c0 89 11 80    	mov    0x801189c0,%edx
8010470c:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
        m_proc = q3[i];
80104712:	8b 3c b5 40 4e 11 80 	mov    -0x7feeb1c0(,%esi,4),%edi
        display_queues();
80104719:	e8 32 f4 ff ff       	call   80103b50 <display_queues>
        switchuvm(m_proc);
8010471e:	83 ec 0c             	sub    $0xc,%esp
        c->proc = m_proc;
80104721:	89 bb ac 00 00 00    	mov    %edi,0xac(%ebx)
        switchuvm(m_proc);
80104727:	57                   	push   %edi
80104728:	e8 03 35 00 00       	call   80107c30 <switchuvm>
        m_proc->num_run++;
8010472d:	83 87 8c 00 00 00 01 	addl   $0x1,0x8c(%edi)
        m_proc->state = RUNNING;
80104734:	c7 47 0c 04 00 00 00 	movl   $0x4,0xc(%edi)
        swtch(&c->scheduler, m_proc->context);
8010473b:	58                   	pop    %eax
8010473c:	5a                   	pop    %edx
8010473d:	ff 77 1c             	pushl  0x1c(%edi)
80104740:	ff 75 e4             	pushl  -0x1c(%ebp)
80104743:	e8 13 12 00 00       	call   8010595b <swtch>
        switchkvm();
80104748:	e8 c3 34 00 00       	call   80107c10 <switchkvm>
        c->proc = 0;
8010474d:	c7 83 ac 00 00 00 00 	movl   $0x0,0xac(%ebx)
80104754:	00 00 00 
        if (m_proc->ticks[3] >= clockperiod[3] || m_proc->killed!=0)
80104757:	83 c4 10             	add    $0x10,%esp
8010475a:	8b 87 a0 00 00 00    	mov    0xa0(%edi),%eax
80104760:	3b 05 14 c0 10 80    	cmp    0x8010c014,%eax
80104766:	0f 8d 8c 01 00 00    	jge    801048f8 <scheduler+0x558>
8010476c:	8b 4f 24             	mov    0x24(%edi),%ecx
8010476f:	8b 15 20 c0 10 80    	mov    0x8010c020,%edx
80104775:	85 c9                	test   %ecx,%ecx
80104777:	0f 84 6b ff ff ff    	je     801046e8 <scheduler+0x348>
          for (j = i; j <= c3 - 1; j++)
8010477d:	39 d6                	cmp    %edx,%esi
8010477f:	7d 27                	jge    801047a8 <scheduler+0x408>
80104781:	8d 04 b5 40 4e 11 80 	lea    -0x7feeb1c0(,%esi,4),%eax
80104788:	8d 0c 95 40 4e 11 80 	lea    -0x7feeb1c0(,%edx,4),%ecx
8010478f:	89 55 e0             	mov    %edx,-0x20(%ebp)
80104792:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            q3[j] = q3[j + 1];
80104798:	8b 50 04             	mov    0x4(%eax),%edx
8010479b:	83 c0 04             	add    $0x4,%eax
8010479e:	89 50 fc             	mov    %edx,-0x4(%eax)
          for (j = i; j <= c3 - 1; j++)
801047a1:	39 c1                	cmp    %eax,%ecx
801047a3:	75 f3                	jne    80104798 <scheduler+0x3f8>
801047a5:	8b 55 e0             	mov    -0x20(%ebp),%edx
          c3--;
801047a8:	83 ea 01             	sub    $0x1,%edx
      for (i = 0; i <= c3; i++)
801047ab:	83 c6 01             	add    $0x1,%esi
          m_proc->ticks[3] = 0;
801047ae:	c7 87 a0 00 00 00 00 	movl   $0x0,0xa0(%edi)
801047b5:	00 00 00 
      for (i = 0; i <= c3; i++)
801047b8:	39 d6                	cmp    %edx,%esi
          c3--;
801047ba:	89 15 20 c0 10 80    	mov    %edx,0x8010c020
      for (i = 0; i <= c3; i++)
801047c0:	0f 8e 2d ff ff ff    	jle    801046f3 <scheduler+0x353>
801047c6:	8d 76 00             	lea    0x0(%esi),%esi
801047c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if (c4 != -1)
801047d0:	8b 35 1c c0 10 80    	mov    0x8010c01c,%esi
801047d6:	85 f6                	test   %esi,%esi
801047d8:	0f 88 ca 00 00 00    	js     801048a8 <scheduler+0x508>
      for (i = 0; i <= c4; i++)
801047de:	31 f6                	xor    %esi,%esi
801047e0:	eb 11                	jmp    801047f3 <scheduler+0x453>
801047e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801047e8:	83 c6 01             	add    $0x1,%esi
801047eb:	39 f2                	cmp    %esi,%edx
801047ed:	0f 8c b5 00 00 00    	jl     801048a8 <scheduler+0x508>
        if (q4[i]->state != RUNNABLE)
801047f3:	8b 04 b5 80 80 11 80 	mov    -0x7fee7f80(,%esi,4),%eax
801047fa:	8b 15 1c c0 10 80    	mov    0x8010c01c,%edx
80104800:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80104804:	75 e2                	jne    801047e8 <scheduler+0x448>
        q4[i]->start=ticks;
80104806:	8b 15 c0 89 11 80    	mov    0x801189c0,%edx
8010480c:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
        m_proc = q4[i];
80104812:	8b 3c b5 80 80 11 80 	mov    -0x7fee7f80(,%esi,4),%edi
        display_queues();
80104819:	e8 32 f3 ff ff       	call   80103b50 <display_queues>
        switchuvm(m_proc);
8010481e:	83 ec 0c             	sub    $0xc,%esp
        c->proc = m_proc;
80104821:	89 bb ac 00 00 00    	mov    %edi,0xac(%ebx)
        switchuvm(m_proc);
80104827:	57                   	push   %edi
80104828:	e8 03 34 00 00       	call   80107c30 <switchuvm>
        m_proc->num_run++;
8010482d:	83 87 8c 00 00 00 01 	addl   $0x1,0x8c(%edi)
        m_proc->state = RUNNING;
80104834:	c7 47 0c 04 00 00 00 	movl   $0x4,0xc(%edi)
        swtch(&c->scheduler, m_proc->context);
8010483b:	58                   	pop    %eax
8010483c:	5a                   	pop    %edx
8010483d:	ff 77 1c             	pushl  0x1c(%edi)
80104840:	ff 75 e4             	pushl  -0x1c(%ebp)
80104843:	e8 13 11 00 00       	call   8010595b <swtch>
        switchkvm();
80104848:	e8 c3 33 00 00       	call   80107c10 <switchkvm>
        c->proc = 0;
8010484d:	c7 83 ac 00 00 00 00 	movl   $0x0,0xac(%ebx)
80104854:	00 00 00 
        if(m_proc->killed!=0)
80104857:	8b 4f 24             	mov    0x24(%edi),%ecx
8010485a:	83 c4 10             	add    $0x10,%esp
          for (j = i; j <= c4 - 1; j++)
8010485d:	8b 15 1c c0 10 80    	mov    0x8010c01c,%edx
        if(m_proc->killed!=0)
80104863:	85 c9                	test   %ecx,%ecx
80104865:	75 59                	jne    801048c0 <scheduler+0x520>
          for (j = i; j <= c4 - 1; j++)
80104867:	39 d6                	cmp    %edx,%esi
80104869:	7d 25                	jge    80104890 <scheduler+0x4f0>
8010486b:	8d 04 b5 80 80 11 80 	lea    -0x7fee7f80(,%esi,4),%eax
80104872:	8d 0c 95 80 80 11 80 	lea    -0x7fee7f80(,%edx,4),%ecx
80104879:	89 55 e0             	mov    %edx,-0x20(%ebp)
8010487c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            q4[j] = q4[j + 1];
80104880:	8b 50 04             	mov    0x4(%eax),%edx
80104883:	83 c0 04             	add    $0x4,%eax
80104886:	89 50 fc             	mov    %edx,-0x4(%eax)
          for (j = i; j <= c4 - 1; j++)
80104889:	39 c1                	cmp    %eax,%ecx
8010488b:	75 f3                	jne    80104880 <scheduler+0x4e0>
8010488d:	8b 55 e0             	mov    -0x20(%ebp),%edx
      for (i = 0; i <= c4; i++)
80104890:	83 c6 01             	add    $0x1,%esi
          q4[c4] = m_proc;
80104893:	89 3c 95 80 80 11 80 	mov    %edi,-0x7fee7f80(,%edx,4)
      for (i = 0; i <= c4; i++)
8010489a:	39 f2                	cmp    %esi,%edx
8010489c:	0f 8d 51 ff ff ff    	jge    801047f3 <scheduler+0x453>
801048a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&ptable.lock);
801048a8:	83 ec 0c             	sub    $0xc,%esp
801048ab:	68 40 51 11 80       	push   $0x80115140
801048b0:	e8 1b 0e 00 00       	call   801056d0 <release>
  {
801048b5:	83 c4 10             	add    $0x10,%esp
801048b8:	e9 03 fb ff ff       	jmp    801043c0 <scheduler+0x20>
801048bd:	8d 76 00             	lea    0x0(%esi),%esi
          for (j = i; j <= c4 - 1; j++)
801048c0:	39 d6                	cmp    %edx,%esi
801048c2:	0f 8d 20 ff ff ff    	jge    801047e8 <scheduler+0x448>
801048c8:	8d 04 b5 80 80 11 80 	lea    -0x7fee7f80(,%esi,4),%eax
801048cf:	8d 3c 95 80 80 11 80 	lea    -0x7fee7f80(,%edx,4),%edi
801048d6:	8d 76 00             	lea    0x0(%esi),%esi
801048d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
            q4[j] = q4[j + 1];
801048e0:	8b 48 04             	mov    0x4(%eax),%ecx
801048e3:	83 c0 04             	add    $0x4,%eax
801048e6:	89 48 fc             	mov    %ecx,-0x4(%eax)
          for (j = i; j <= c4 - 1; j++)
801048e9:	39 f8                	cmp    %edi,%eax
801048eb:	75 f3                	jne    801048e0 <scheduler+0x540>
801048ed:	e9 f6 fe ff ff       	jmp    801047e8 <scheduler+0x448>
801048f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
          if (m_proc->killed == 0)
801048f8:	8b 57 24             	mov    0x24(%edi),%edx
801048fb:	85 d2                	test   %edx,%edx
801048fd:	0f 85 d5 00 00 00    	jne    801049d8 <scheduler+0x638>
            cprintf("\033[1;31m(%d, %s) switching to queue 4     since ticks of [3]= %d\n\033[0m", m_proc->pid, m_proc->name, m_proc->ticks[3]);
80104903:	50                   	push   %eax
80104904:	8d 47 6c             	lea    0x6c(%edi),%eax
80104907:	50                   	push   %eax
80104908:	ff 77 10             	pushl  0x10(%edi)
8010490b:	68 f4 8b 10 80       	push   $0x80108bf4
80104910:	e8 4b bd ff ff       	call   80100660 <cprintf>
            c4++;
80104915:	a1 1c c0 10 80       	mov    0x8010c01c,%eax
            m_proc->current_queue++;
8010491a:	83 87 b8 00 00 00 01 	addl   $0x1,0xb8(%edi)
80104921:	83 c4 10             	add    $0x10,%esp
80104924:	8b 15 20 c0 10 80    	mov    0x8010c020,%edx
            c4++;
8010492a:	83 c0 01             	add    $0x1,%eax
8010492d:	a3 1c c0 10 80       	mov    %eax,0x8010c01c
            q4[c4] = m_proc;
80104932:	89 3c 85 80 80 11 80 	mov    %edi,-0x7fee7f80(,%eax,4)
80104939:	e9 3f fe ff ff       	jmp    8010477d <scheduler+0x3dd>
8010493e:	66 90                	xchg   %ax,%ax
          if (m_proc->killed == 0)
80104940:	8b 57 24             	mov    0x24(%edi),%edx
80104943:	85 d2                	test   %edx,%edx
80104945:	0f 85 ad 00 00 00    	jne    801049f8 <scheduler+0x658>
            cprintf("\033[1;31m(%d, %s) switching to queue 3     since ticks of [2]= %d\n\033[0m", m_proc->pid, m_proc->name, m_proc->ticks[2]);
8010494b:	50                   	push   %eax
8010494c:	8d 47 6c             	lea    0x6c(%edi),%eax
8010494f:	50                   	push   %eax
80104950:	ff 77 10             	pushl  0x10(%edi)
80104953:	68 ac 8b 10 80       	push   $0x80108bac
80104958:	e8 03 bd ff ff       	call   80100660 <cprintf>
            c3++;
8010495d:	a1 20 c0 10 80       	mov    0x8010c020,%eax
            m_proc->current_queue++;
80104962:	83 87 b8 00 00 00 01 	addl   $0x1,0xb8(%edi)
80104969:	83 c4 10             	add    $0x10,%esp
8010496c:	8b 15 24 c0 10 80    	mov    0x8010c024,%edx
            c3++;
80104972:	83 c0 01             	add    $0x1,%eax
80104975:	a3 20 c0 10 80       	mov    %eax,0x8010c020
            q3[c3] = m_proc;
8010497a:	89 3c 85 40 4e 11 80 	mov    %edi,-0x7feeb1c0(,%eax,4)
80104981:	e9 f7 fc ff ff       	jmp    8010467d <scheduler+0x2dd>
80104986:	8d 76 00             	lea    0x0(%esi),%esi
80104989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
          if (m_proc->killed == 0)
80104990:	8b 57 24             	mov    0x24(%edi),%edx
80104993:	85 d2                	test   %edx,%edx
80104995:	75 51                	jne    801049e8 <scheduler+0x648>
            cprintf("\033[1;31m(%d, %s) switching to queue 2      since ticks of [1]= %d\n\033[0m", m_proc->pid, m_proc->name, m_proc->ticks[1]);
80104997:	50                   	push   %eax
80104998:	8d 47 6c             	lea    0x6c(%edi),%eax
8010499b:	50                   	push   %eax
8010499c:	ff 77 10             	pushl  0x10(%edi)
8010499f:	68 64 8b 10 80       	push   $0x80108b64
801049a4:	e8 b7 bc ff ff       	call   80100660 <cprintf>
            c2++;
801049a9:	a1 24 c0 10 80       	mov    0x8010c024,%eax
            m_proc->current_queue++;
801049ae:	83 87 b8 00 00 00 01 	addl   $0x1,0xb8(%edi)
801049b5:	83 c4 10             	add    $0x10,%esp
801049b8:	8b 15 28 c0 10 80    	mov    0x8010c028,%edx
            c2++;
801049be:	83 c0 01             	add    $0x1,%eax
801049c1:	a3 24 c0 10 80       	mov    %eax,0x8010c024
            q2[c2] = m_proc;
801049c6:	89 3c 85 40 4d 11 80 	mov    %edi,-0x7feeb2c0(,%eax,4)
801049cd:	e9 ab fb ff ff       	jmp    8010457d <scheduler+0x1dd>
801049d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801049d8:	8b 15 20 c0 10 80    	mov    0x8010c020,%edx
801049de:	e9 9a fd ff ff       	jmp    8010477d <scheduler+0x3dd>
801049e3:	90                   	nop
801049e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801049e8:	8b 15 28 c0 10 80    	mov    0x8010c028,%edx
801049ee:	e9 8a fb ff ff       	jmp    8010457d <scheduler+0x1dd>
801049f3:	90                   	nop
801049f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801049f8:	8b 15 24 c0 10 80    	mov    0x8010c024,%edx
801049fe:	e9 7a fc ff ff       	jmp    8010467d <scheduler+0x2dd>
80104a03:	90                   	nop
80104a04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            cprintf("\033[1;31m (%d,%s) switching to queue 1      since ticks of [0]= %d\n\033[0m", m_proc->pid,m_proc->name, m_proc->ticks[0]);
80104a08:	50                   	push   %eax
80104a09:	8d 47 6c             	lea    0x6c(%edi),%eax
80104a0c:	50                   	push   %eax
80104a0d:	52                   	push   %edx
80104a0e:	68 1c 8b 10 80       	push   $0x80108b1c
80104a13:	e8 48 bc ff ff       	call   80100660 <cprintf>
            c1++;
80104a18:	a1 28 c0 10 80       	mov    0x8010c028,%eax
            m_proc->current_queue++;
80104a1d:	83 87 b8 00 00 00 01 	addl   $0x1,0xb8(%edi)
            q1[c1] = m_proc;
80104a24:	83 c4 10             	add    $0x10,%esp
            c1++;
80104a27:	83 c0 01             	add    $0x1,%eax
80104a2a:	a3 28 c0 10 80       	mov    %eax,0x8010c028
            q1[c1] = m_proc;
80104a2f:	89 3c 85 40 4f 11 80 	mov    %edi,-0x7feeb0c0(,%eax,4)
80104a36:	e9 4b fa ff ff       	jmp    80104486 <scheduler+0xe6>
80104a3b:	90                   	nop
80104a3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104a40 <sched>:
{
80104a40:	55                   	push   %ebp
80104a41:	89 e5                	mov    %esp,%ebp
80104a43:	56                   	push   %esi
80104a44:	53                   	push   %ebx
  pushcli();
80104a45:	e8 f6 0a 00 00       	call   80105540 <pushcli>
  c = mycpu();
80104a4a:	e8 b1 ed ff ff       	call   80103800 <mycpu>
  p = c->proc;
80104a4f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104a55:	e8 26 0b 00 00       	call   80105580 <popcli>
  if (!holding(&ptable.lock))
80104a5a:	83 ec 0c             	sub    $0xc,%esp
80104a5d:	68 40 51 11 80       	push   $0x80115140
80104a62:	e8 79 0b 00 00       	call   801055e0 <holding>
80104a67:	83 c4 10             	add    $0x10,%esp
80104a6a:	85 c0                	test   %eax,%eax
80104a6c:	74 4f                	je     80104abd <sched+0x7d>
  if (mycpu()->ncli != 1)
80104a6e:	e8 8d ed ff ff       	call   80103800 <mycpu>
80104a73:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80104a7a:	75 68                	jne    80104ae4 <sched+0xa4>
  if (p->state == RUNNING)
80104a7c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80104a80:	74 55                	je     80104ad7 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104a82:	9c                   	pushf  
80104a83:	58                   	pop    %eax
  if (readeflags() & FL_IF)
80104a84:	f6 c4 02             	test   $0x2,%ah
80104a87:	75 41                	jne    80104aca <sched+0x8a>
  intena = mycpu()->intena;
80104a89:	e8 72 ed ff ff       	call   80103800 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80104a8e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80104a91:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80104a97:	e8 64 ed ff ff       	call   80103800 <mycpu>
80104a9c:	83 ec 08             	sub    $0x8,%esp
80104a9f:	ff 70 04             	pushl  0x4(%eax)
80104aa2:	53                   	push   %ebx
80104aa3:	e8 b3 0e 00 00       	call   8010595b <swtch>
  mycpu()->intena = intena;
80104aa8:	e8 53 ed ff ff       	call   80103800 <mycpu>
}
80104aad:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80104ab0:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80104ab6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ab9:	5b                   	pop    %ebx
80104aba:	5e                   	pop    %esi
80104abb:	5d                   	pop    %ebp
80104abc:	c3                   	ret    
    panic("sched ptable.lock");
80104abd:	83 ec 0c             	sub    $0xc,%esp
80104ac0:	68 dd 88 10 80       	push   $0x801088dd
80104ac5:	e8 c6 b8 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
80104aca:	83 ec 0c             	sub    $0xc,%esp
80104acd:	68 09 89 10 80       	push   $0x80108909
80104ad2:	e8 b9 b8 ff ff       	call   80100390 <panic>
    panic("sched running");
80104ad7:	83 ec 0c             	sub    $0xc,%esp
80104ada:	68 fb 88 10 80       	push   $0x801088fb
80104adf:	e8 ac b8 ff ff       	call   80100390 <panic>
    panic("sched locks");
80104ae4:	83 ec 0c             	sub    $0xc,%esp
80104ae7:	68 ef 88 10 80       	push   $0x801088ef
80104aec:	e8 9f b8 ff ff       	call   80100390 <panic>
80104af1:	eb 0d                	jmp    80104b00 <exit>
80104af3:	90                   	nop
80104af4:	90                   	nop
80104af5:	90                   	nop
80104af6:	90                   	nop
80104af7:	90                   	nop
80104af8:	90                   	nop
80104af9:	90                   	nop
80104afa:	90                   	nop
80104afb:	90                   	nop
80104afc:	90                   	nop
80104afd:	90                   	nop
80104afe:	90                   	nop
80104aff:	90                   	nop

80104b00 <exit>:
{
80104b00:	55                   	push   %ebp
80104b01:	89 e5                	mov    %esp,%ebp
80104b03:	57                   	push   %edi
80104b04:	56                   	push   %esi
80104b05:	53                   	push   %ebx
80104b06:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80104b09:	e8 32 0a 00 00       	call   80105540 <pushcli>
  c = mycpu();
80104b0e:	e8 ed ec ff ff       	call   80103800 <mycpu>
  p = c->proc;
80104b13:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104b19:	e8 62 0a 00 00       	call   80105580 <popcli>
  if (curproc == initproc)
80104b1e:	39 35 d8 c5 10 80    	cmp    %esi,0x8010c5d8
80104b24:	8d 5e 28             	lea    0x28(%esi),%ebx
80104b27:	8d 7e 68             	lea    0x68(%esi),%edi
80104b2a:	0f 84 fc 00 00 00    	je     80104c2c <exit+0x12c>
    if (curproc->ofile[fd])
80104b30:	8b 03                	mov    (%ebx),%eax
80104b32:	85 c0                	test   %eax,%eax
80104b34:	74 12                	je     80104b48 <exit+0x48>
      fileclose(curproc->ofile[fd]);
80104b36:	83 ec 0c             	sub    $0xc,%esp
80104b39:	50                   	push   %eax
80104b3a:	e8 01 c3 ff ff       	call   80100e40 <fileclose>
      curproc->ofile[fd] = 0;
80104b3f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80104b45:	83 c4 10             	add    $0x10,%esp
80104b48:	83 c3 04             	add    $0x4,%ebx
  for (fd = 0; fd < NOFILE; fd++)
80104b4b:	39 fb                	cmp    %edi,%ebx
80104b4d:	75 e1                	jne    80104b30 <exit+0x30>
  begin_op();
80104b4f:	e8 4c e0 ff ff       	call   80102ba0 <begin_op>
  iput(curproc->cwd);
80104b54:	83 ec 0c             	sub    $0xc,%esp
80104b57:	ff 76 68             	pushl  0x68(%esi)
80104b5a:	e8 51 cc ff ff       	call   801017b0 <iput>
  end_op();
80104b5f:	e8 ac e0 ff ff       	call   80102c10 <end_op>
  curproc->cwd = 0;
80104b64:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
80104b6b:	c7 04 24 40 51 11 80 	movl   $0x80115140,(%esp)
80104b72:	e8 99 0a 00 00       	call   80105610 <acquire>
  wakeup1(curproc->parent);
80104b77:	8b 56 14             	mov    0x14(%esi),%edx
80104b7a:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104b7d:	b8 74 51 11 80       	mov    $0x80115174,%eax
80104b82:	eb 10                	jmp    80104b94 <exit+0x94>
80104b84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104b88:	05 bc 00 00 00       	add    $0xbc,%eax
80104b8d:	3d 74 80 11 80       	cmp    $0x80118074,%eax
80104b92:	73 1e                	jae    80104bb2 <exit+0xb2>
    if (p->state == SLEEPING && p->chan == chan)
80104b94:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104b98:	75 ee                	jne    80104b88 <exit+0x88>
80104b9a:	3b 50 20             	cmp    0x20(%eax),%edx
80104b9d:	75 e9                	jne    80104b88 <exit+0x88>
      p->state = RUNNABLE;
80104b9f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104ba6:	05 bc 00 00 00       	add    $0xbc,%eax
80104bab:	3d 74 80 11 80       	cmp    $0x80118074,%eax
80104bb0:	72 e2                	jb     80104b94 <exit+0x94>
      p->parent = initproc;
80104bb2:	8b 0d d8 c5 10 80    	mov    0x8010c5d8,%ecx
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104bb8:	ba 74 51 11 80       	mov    $0x80115174,%edx
80104bbd:	eb 0f                	jmp    80104bce <exit+0xce>
80104bbf:	90                   	nop
80104bc0:	81 c2 bc 00 00 00    	add    $0xbc,%edx
80104bc6:	81 fa 74 80 11 80    	cmp    $0x80118074,%edx
80104bcc:	73 3a                	jae    80104c08 <exit+0x108>
    if (p->parent == curproc)
80104bce:	39 72 14             	cmp    %esi,0x14(%edx)
80104bd1:	75 ed                	jne    80104bc0 <exit+0xc0>
      if (p->state == ZOMBIE)
80104bd3:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80104bd7:	89 4a 14             	mov    %ecx,0x14(%edx)
      if (p->state == ZOMBIE)
80104bda:	75 e4                	jne    80104bc0 <exit+0xc0>
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104bdc:	b8 74 51 11 80       	mov    $0x80115174,%eax
80104be1:	eb 11                	jmp    80104bf4 <exit+0xf4>
80104be3:	90                   	nop
80104be4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104be8:	05 bc 00 00 00       	add    $0xbc,%eax
80104bed:	3d 74 80 11 80       	cmp    $0x80118074,%eax
80104bf2:	73 cc                	jae    80104bc0 <exit+0xc0>
    if (p->state == SLEEPING && p->chan == chan)
80104bf4:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104bf8:	75 ee                	jne    80104be8 <exit+0xe8>
80104bfa:	3b 48 20             	cmp    0x20(%eax),%ecx
80104bfd:	75 e9                	jne    80104be8 <exit+0xe8>
      p->state = RUNNABLE;
80104bff:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80104c06:	eb e0                	jmp    80104be8 <exit+0xe8>
  curproc->etime = ticks; // TODO Might need to protect the read of ticks with a lock
80104c08:	a1 c0 89 11 80       	mov    0x801189c0,%eax
  curproc->state = ZOMBIE;
80104c0d:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  curproc->etime = ticks; // TODO Might need to protect the read of ticks with a lock
80104c14:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
  sched();
80104c1a:	e8 21 fe ff ff       	call   80104a40 <sched>
  panic("zombie exit");
80104c1f:	83 ec 0c             	sub    $0xc,%esp
80104c22:	68 2a 89 10 80       	push   $0x8010892a
80104c27:	e8 64 b7 ff ff       	call   80100390 <panic>
    panic("init exiting");
80104c2c:	83 ec 0c             	sub    $0xc,%esp
80104c2f:	68 1d 89 10 80       	push   $0x8010891d
80104c34:	e8 57 b7 ff ff       	call   80100390 <panic>
80104c39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104c40 <yield>:
{
80104c40:	55                   	push   %ebp
80104c41:	89 e5                	mov    %esp,%ebp
80104c43:	53                   	push   %ebx
80104c44:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock); //DOC: yieldlock
80104c47:	68 40 51 11 80       	push   $0x80115140
80104c4c:	e8 bf 09 00 00       	call   80105610 <acquire>
  pushcli();
80104c51:	e8 ea 08 00 00       	call   80105540 <pushcli>
  c = mycpu();
80104c56:	e8 a5 eb ff ff       	call   80103800 <mycpu>
  p = c->proc;
80104c5b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104c61:	e8 1a 09 00 00       	call   80105580 <popcli>
  myproc()->state = RUNNABLE;
80104c66:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
80104c6d:	e8 ce fd ff ff       	call   80104a40 <sched>
  release(&ptable.lock);
80104c72:	c7 04 24 40 51 11 80 	movl   $0x80115140,(%esp)
80104c79:	e8 52 0a 00 00       	call   801056d0 <release>
}
80104c7e:	83 c4 10             	add    $0x10,%esp
80104c81:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c84:	c9                   	leave  
80104c85:	c3                   	ret    
80104c86:	8d 76 00             	lea    0x0(%esi),%esi
80104c89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c90 <sleep>:
{
80104c90:	55                   	push   %ebp
80104c91:	89 e5                	mov    %esp,%ebp
80104c93:	57                   	push   %edi
80104c94:	56                   	push   %esi
80104c95:	53                   	push   %ebx
80104c96:	83 ec 0c             	sub    $0xc,%esp
80104c99:	8b 7d 08             	mov    0x8(%ebp),%edi
80104c9c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
80104c9f:	e8 9c 08 00 00       	call   80105540 <pushcli>
  c = mycpu();
80104ca4:	e8 57 eb ff ff       	call   80103800 <mycpu>
  p = c->proc;
80104ca9:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104caf:	e8 cc 08 00 00       	call   80105580 <popcli>
  if (p == 0)
80104cb4:	85 db                	test   %ebx,%ebx
80104cb6:	0f 84 87 00 00 00    	je     80104d43 <sleep+0xb3>
  if (lk == 0)
80104cbc:	85 f6                	test   %esi,%esi
80104cbe:	74 76                	je     80104d36 <sleep+0xa6>
  if (lk != &ptable.lock)
80104cc0:	81 fe 40 51 11 80    	cmp    $0x80115140,%esi
80104cc6:	74 50                	je     80104d18 <sleep+0x88>
    acquire(&ptable.lock); //DOC: sleeplock1
80104cc8:	83 ec 0c             	sub    $0xc,%esp
80104ccb:	68 40 51 11 80       	push   $0x80115140
80104cd0:	e8 3b 09 00 00       	call   80105610 <acquire>
    release(lk);
80104cd5:	89 34 24             	mov    %esi,(%esp)
80104cd8:	e8 f3 09 00 00       	call   801056d0 <release>
  p->chan = chan;
80104cdd:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104ce0:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104ce7:	e8 54 fd ff ff       	call   80104a40 <sched>
  p->chan = 0;
80104cec:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104cf3:	c7 04 24 40 51 11 80 	movl   $0x80115140,(%esp)
80104cfa:	e8 d1 09 00 00       	call   801056d0 <release>
    acquire(lk);
80104cff:	89 75 08             	mov    %esi,0x8(%ebp)
80104d02:	83 c4 10             	add    $0x10,%esp
}
80104d05:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104d08:	5b                   	pop    %ebx
80104d09:	5e                   	pop    %esi
80104d0a:	5f                   	pop    %edi
80104d0b:	5d                   	pop    %ebp
    acquire(lk);
80104d0c:	e9 ff 08 00 00       	jmp    80105610 <acquire>
80104d11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80104d18:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104d1b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104d22:	e8 19 fd ff ff       	call   80104a40 <sched>
  p->chan = 0;
80104d27:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80104d2e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104d31:	5b                   	pop    %ebx
80104d32:	5e                   	pop    %esi
80104d33:	5f                   	pop    %edi
80104d34:	5d                   	pop    %ebp
80104d35:	c3                   	ret    
    panic("sleep without lk");
80104d36:	83 ec 0c             	sub    $0xc,%esp
80104d39:	68 3c 89 10 80       	push   $0x8010893c
80104d3e:	e8 4d b6 ff ff       	call   80100390 <panic>
    panic("sleep");
80104d43:	83 ec 0c             	sub    $0xc,%esp
80104d46:	68 36 89 10 80       	push   $0x80108936
80104d4b:	e8 40 b6 ff ff       	call   80100390 <panic>

80104d50 <wait>:
{
80104d50:	55                   	push   %ebp
80104d51:	89 e5                	mov    %esp,%ebp
80104d53:	56                   	push   %esi
80104d54:	53                   	push   %ebx
  pushcli();
80104d55:	e8 e6 07 00 00       	call   80105540 <pushcli>
  c = mycpu();
80104d5a:	e8 a1 ea ff ff       	call   80103800 <mycpu>
  p = c->proc;
80104d5f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104d65:	e8 16 08 00 00       	call   80105580 <popcli>
  acquire(&ptable.lock);
80104d6a:	83 ec 0c             	sub    $0xc,%esp
80104d6d:	68 40 51 11 80       	push   $0x80115140
80104d72:	e8 99 08 00 00       	call   80105610 <acquire>
80104d77:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80104d7a:	31 c0                	xor    %eax,%eax
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104d7c:	bb 74 51 11 80       	mov    $0x80115174,%ebx
80104d81:	eb 13                	jmp    80104d96 <wait+0x46>
80104d83:	90                   	nop
80104d84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104d88:	81 c3 bc 00 00 00    	add    $0xbc,%ebx
80104d8e:	81 fb 74 80 11 80    	cmp    $0x80118074,%ebx
80104d94:	73 1e                	jae    80104db4 <wait+0x64>
      if (p->parent != curproc)
80104d96:	39 73 14             	cmp    %esi,0x14(%ebx)
80104d99:	75 ed                	jne    80104d88 <wait+0x38>
      if (p->state == ZOMBIE)
80104d9b:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80104d9f:	74 3f                	je     80104de0 <wait+0x90>
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104da1:	81 c3 bc 00 00 00    	add    $0xbc,%ebx
      havekids = 1;
80104da7:	b8 01 00 00 00       	mov    $0x1,%eax
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104dac:	81 fb 74 80 11 80    	cmp    $0x80118074,%ebx
80104db2:	72 e2                	jb     80104d96 <wait+0x46>
    if (!havekids || curproc->killed)
80104db4:	85 c0                	test   %eax,%eax
80104db6:	0f 84 8a 00 00 00    	je     80104e46 <wait+0xf6>
80104dbc:	8b 46 24             	mov    0x24(%esi),%eax
80104dbf:	85 c0                	test   %eax,%eax
80104dc1:	0f 85 7f 00 00 00    	jne    80104e46 <wait+0xf6>
    sleep(curproc, &ptable.lock); //DOC: wait-sleep
80104dc7:	83 ec 08             	sub    $0x8,%esp
80104dca:	68 40 51 11 80       	push   $0x80115140
80104dcf:	56                   	push   %esi
80104dd0:	e8 bb fe ff ff       	call   80104c90 <sleep>
    havekids = 0;
80104dd5:	83 c4 10             	add    $0x10,%esp
80104dd8:	eb a0                	jmp    80104d7a <wait+0x2a>
80104dda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        kfree(p->kstack);
80104de0:	83 ec 0c             	sub    $0xc,%esp
80104de3:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
80104de6:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104de9:	e8 22 d5 ff ff       	call   80102310 <kfree>
        freevm(p->pgdir);
80104dee:	5a                   	pop    %edx
80104def:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
80104df2:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104df9:	e8 e2 31 00 00       	call   80107fe0 <freevm>
        rem_process(p->pid,p->current_queue); //Removing zombie processses from the queue
80104dfe:	59                   	pop    %ecx
80104dff:	58                   	pop    %eax
80104e00:	ff b3 b8 00 00 00    	pushl  0xb8(%ebx)
80104e06:	ff 73 10             	pushl  0x10(%ebx)
80104e09:	e8 c2 ea ff ff       	call   801038d0 <rem_process>
        release(&ptable.lock);
80104e0e:	c7 04 24 40 51 11 80 	movl   $0x80115140,(%esp)
        p->pid = 0;
80104e15:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80104e1c:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80104e23:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104e27:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80104e2e:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80104e35:	e8 96 08 00 00       	call   801056d0 <release>
        return pid;
80104e3a:	83 c4 10             	add    $0x10,%esp
}
80104e3d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e40:	89 f0                	mov    %esi,%eax
80104e42:	5b                   	pop    %ebx
80104e43:	5e                   	pop    %esi
80104e44:	5d                   	pop    %ebp
80104e45:	c3                   	ret    
      release(&ptable.lock);
80104e46:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104e49:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80104e4e:	68 40 51 11 80       	push   $0x80115140
80104e53:	e8 78 08 00 00       	call   801056d0 <release>
      return -1;
80104e58:	83 c4 10             	add    $0x10,%esp
80104e5b:	eb e0                	jmp    80104e3d <wait+0xed>
80104e5d:	8d 76 00             	lea    0x0(%esi),%esi

80104e60 <waitx>:
{
80104e60:	55                   	push   %ebp
80104e61:	89 e5                	mov    %esp,%ebp
80104e63:	56                   	push   %esi
80104e64:	53                   	push   %ebx
  pushcli();
80104e65:	e8 d6 06 00 00       	call   80105540 <pushcli>
  c = mycpu();
80104e6a:	e8 91 e9 ff ff       	call   80103800 <mycpu>
  p = c->proc;
80104e6f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104e75:	e8 06 07 00 00       	call   80105580 <popcli>
  acquire(&ptable.lock);
80104e7a:	83 ec 0c             	sub    $0xc,%esp
80104e7d:	68 40 51 11 80       	push   $0x80115140
80104e82:	e8 89 07 00 00       	call   80105610 <acquire>
80104e87:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80104e8a:	31 c0                	xor    %eax,%eax
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104e8c:	bb 74 51 11 80       	mov    $0x80115174,%ebx
80104e91:	eb 13                	jmp    80104ea6 <waitx+0x46>
80104e93:	90                   	nop
80104e94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104e98:	81 c3 bc 00 00 00    	add    $0xbc,%ebx
80104e9e:	81 fb 74 80 11 80    	cmp    $0x80118074,%ebx
80104ea4:	73 1e                	jae    80104ec4 <waitx+0x64>
      if (p->parent != curproc)
80104ea6:	39 73 14             	cmp    %esi,0x14(%ebx)
80104ea9:	75 ed                	jne    80104e98 <waitx+0x38>
      if (p->state == ZOMBIE)
80104eab:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80104eaf:	74 3f                	je     80104ef0 <waitx+0x90>
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104eb1:	81 c3 bc 00 00 00    	add    $0xbc,%ebx
      havekids = 1;
80104eb7:	b8 01 00 00 00       	mov    $0x1,%eax
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104ebc:	81 fb 74 80 11 80    	cmp    $0x80118074,%ebx
80104ec2:	72 e2                	jb     80104ea6 <waitx+0x46>
    if (!havekids || curproc->killed)
80104ec4:	85 c0                	test   %eax,%eax
80104ec6:	0f 84 c1 00 00 00    	je     80104f8d <waitx+0x12d>
80104ecc:	8b 46 24             	mov    0x24(%esi),%eax
80104ecf:	85 c0                	test   %eax,%eax
80104ed1:	0f 85 b6 00 00 00    	jne    80104f8d <waitx+0x12d>
    sleep(curproc, &ptable.lock); //DOC: wait-sleep
80104ed7:	83 ec 08             	sub    $0x8,%esp
80104eda:	68 40 51 11 80       	push   $0x80115140
80104edf:	56                   	push   %esi
80104ee0:	e8 ab fd ff ff       	call   80104c90 <sleep>
    havekids = 0;
80104ee5:	83 c4 10             	add    $0x10,%esp
80104ee8:	eb a0                	jmp    80104e8a <waitx+0x2a>
80104eea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        cprintf("\netime %d  ctime %d    rtime %d    iotime %d \n", p->etime, p->ctime, p->rtime, p->iotime);
80104ef0:	83 ec 0c             	sub    $0xc,%esp
80104ef3:	ff b3 88 00 00 00    	pushl  0x88(%ebx)
80104ef9:	ff b3 84 00 00 00    	pushl  0x84(%ebx)
80104eff:	ff 73 7c             	pushl  0x7c(%ebx)
80104f02:	ff b3 80 00 00 00    	pushl  0x80(%ebx)
80104f08:	68 3c 8c 10 80       	push   $0x80108c3c
80104f0d:	e8 4e b7 ff ff       	call   80100660 <cprintf>
        *wtime = p->etime - p->ctime - p->rtime - p->iotime;
80104f12:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
80104f18:	2b 43 7c             	sub    0x7c(%ebx),%eax
        kfree(p->kstack);
80104f1b:	83 c4 14             	add    $0x14,%esp
        *wtime = p->etime - p->ctime - p->rtime - p->iotime;
80104f1e:	2b 83 84 00 00 00    	sub    0x84(%ebx),%eax
80104f24:	8b 55 08             	mov    0x8(%ebp),%edx
80104f27:	2b 83 88 00 00 00    	sub    0x88(%ebx),%eax
80104f2d:	89 02                	mov    %eax,(%edx)
        *rtime = p->rtime;
80104f2f:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f32:	8b 93 84 00 00 00    	mov    0x84(%ebx),%edx
80104f38:	89 10                	mov    %edx,(%eax)
        kfree(p->kstack);
80104f3a:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
80104f3d:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104f40:	e8 cb d3 ff ff       	call   80102310 <kfree>
        freevm(p->pgdir);
80104f45:	5a                   	pop    %edx
80104f46:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
80104f49:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104f50:	e8 8b 30 00 00       	call   80107fe0 <freevm>
        release(&ptable.lock);
80104f55:	c7 04 24 40 51 11 80 	movl   $0x80115140,(%esp)
        p->state = UNUSED;
80104f5c:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        p->pid = 0;
80104f63:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80104f6a:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80104f71:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104f75:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        release(&ptable.lock);
80104f7c:	e8 4f 07 00 00       	call   801056d0 <release>
        return pid;
80104f81:	83 c4 10             	add    $0x10,%esp
}
80104f84:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f87:	89 f0                	mov    %esi,%eax
80104f89:	5b                   	pop    %ebx
80104f8a:	5e                   	pop    %esi
80104f8b:	5d                   	pop    %ebp
80104f8c:	c3                   	ret    
      release(&ptable.lock);
80104f8d:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104f90:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80104f95:	68 40 51 11 80       	push   $0x80115140
80104f9a:	e8 31 07 00 00       	call   801056d0 <release>
      return -1;
80104f9f:	83 c4 10             	add    $0x10,%esp
80104fa2:	eb e0                	jmp    80104f84 <waitx+0x124>
80104fa4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104faa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104fb0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void wakeup(void *chan)
{
80104fb0:	55                   	push   %ebp
80104fb1:	89 e5                	mov    %esp,%ebp
80104fb3:	53                   	push   %ebx
80104fb4:	83 ec 10             	sub    $0x10,%esp
80104fb7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80104fba:	68 40 51 11 80       	push   $0x80115140
80104fbf:	e8 4c 06 00 00       	call   80105610 <acquire>
80104fc4:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104fc7:	b8 74 51 11 80       	mov    $0x80115174,%eax
80104fcc:	eb 0e                	jmp    80104fdc <wakeup+0x2c>
80104fce:	66 90                	xchg   %ax,%ax
80104fd0:	05 bc 00 00 00       	add    $0xbc,%eax
80104fd5:	3d 74 80 11 80       	cmp    $0x80118074,%eax
80104fda:	73 1e                	jae    80104ffa <wakeup+0x4a>
    if (p->state == SLEEPING && p->chan == chan)
80104fdc:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104fe0:	75 ee                	jne    80104fd0 <wakeup+0x20>
80104fe2:	3b 58 20             	cmp    0x20(%eax),%ebx
80104fe5:	75 e9                	jne    80104fd0 <wakeup+0x20>
      p->state = RUNNABLE;
80104fe7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104fee:	05 bc 00 00 00       	add    $0xbc,%eax
80104ff3:	3d 74 80 11 80       	cmp    $0x80118074,%eax
80104ff8:	72 e2                	jb     80104fdc <wakeup+0x2c>
  wakeup1(chan);
  release(&ptable.lock);
80104ffa:	c7 45 08 40 51 11 80 	movl   $0x80115140,0x8(%ebp)
}
80105001:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105004:	c9                   	leave  
  release(&ptable.lock);
80105005:	e9 c6 06 00 00       	jmp    801056d0 <release>
8010500a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105010 <kill>:

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int kill(int pid)
{
80105010:	55                   	push   %ebp
80105011:	89 e5                	mov    %esp,%ebp
80105013:	53                   	push   %ebx
80105014:	83 ec 10             	sub    $0x10,%esp
80105017:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010501a:	68 40 51 11 80       	push   $0x80115140
8010501f:	e8 ec 05 00 00       	call   80105610 <acquire>
80105024:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80105027:	b8 74 51 11 80       	mov    $0x80115174,%eax
8010502c:	eb 0e                	jmp    8010503c <kill+0x2c>
8010502e:	66 90                	xchg   %ax,%ax
80105030:	05 bc 00 00 00       	add    $0xbc,%eax
80105035:	3d 74 80 11 80       	cmp    $0x80118074,%eax
8010503a:	73 34                	jae    80105070 <kill+0x60>
  {
    if (p->pid == pid)
8010503c:	39 58 10             	cmp    %ebx,0x10(%eax)
8010503f:	75 ef                	jne    80105030 <kill+0x20>
    {
      p->killed = 1;
      // Wake process from sleep if necessary.
      if (p->state == SLEEPING)
80105041:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80105045:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if (p->state == SLEEPING)
8010504c:	75 07                	jne    80105055 <kill+0x45>
        p->state = RUNNABLE;
8010504e:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80105055:	83 ec 0c             	sub    $0xc,%esp
80105058:	68 40 51 11 80       	push   $0x80115140
8010505d:	e8 6e 06 00 00       	call   801056d0 <release>
      return 0;
80105062:	83 c4 10             	add    $0x10,%esp
80105065:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80105067:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010506a:	c9                   	leave  
8010506b:	c3                   	ret    
8010506c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80105070:	83 ec 0c             	sub    $0xc,%esp
80105073:	68 40 51 11 80       	push   $0x80115140
80105078:	e8 53 06 00 00       	call   801056d0 <release>
  return -1;
8010507d:	83 c4 10             	add    $0x10,%esp
80105080:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105085:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105088:	c9                   	leave  
80105089:	c3                   	ret    
8010508a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105090 <procdump>:
//PAGEBREAK: 36
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void procdump(void)
{
80105090:	55                   	push   %ebp
80105091:	89 e5                	mov    %esp,%ebp
80105093:	57                   	push   %edi
80105094:	56                   	push   %esi
80105095:	53                   	push   %ebx
80105096:	8d 75 e8             	lea    -0x18(%ebp),%esi
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80105099:	bb 74 51 11 80       	mov    $0x80115174,%ebx
{
8010509e:	83 ec 3c             	sub    $0x3c,%esp
801050a1:	eb 27                	jmp    801050ca <procdump+0x3a>
801050a3:	90                   	nop
801050a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    {
      getcallerpcs((uint *)p->context->ebp + 2, pc);
      for (i = 0; i < 10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801050a8:	83 ec 0c             	sub    $0xc,%esp
801050ab:	68 37 90 10 80       	push   $0x80109037
801050b0:	e8 ab b5 ff ff       	call   80100660 <cprintf>
801050b5:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801050b8:	81 c3 bc 00 00 00    	add    $0xbc,%ebx
801050be:	81 fb 74 80 11 80    	cmp    $0x80118074,%ebx
801050c4:	0f 83 86 00 00 00    	jae    80105150 <procdump+0xc0>
    if (p->state == UNUSED)
801050ca:	8b 43 0c             	mov    0xc(%ebx),%eax
801050cd:	85 c0                	test   %eax,%eax
801050cf:	74 e7                	je     801050b8 <procdump+0x28>
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
801050d1:	83 f8 05             	cmp    $0x5,%eax
      state = "???";
801050d4:	ba 4d 89 10 80       	mov    $0x8010894d,%edx
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
801050d9:	77 11                	ja     801050ec <procdump+0x5c>
801050db:	8b 14 85 04 8d 10 80 	mov    -0x7fef72fc(,%eax,4),%edx
      state = "???";
801050e2:	b8 4d 89 10 80       	mov    $0x8010894d,%eax
801050e7:	85 d2                	test   %edx,%edx
801050e9:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
801050ec:	8d 43 6c             	lea    0x6c(%ebx),%eax
801050ef:	50                   	push   %eax
801050f0:	52                   	push   %edx
801050f1:	ff 73 10             	pushl  0x10(%ebx)
801050f4:	68 51 89 10 80       	push   $0x80108951
801050f9:	e8 62 b5 ff ff       	call   80100660 <cprintf>
    if (p->state == SLEEPING)
801050fe:	83 c4 10             	add    $0x10,%esp
80105101:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
80105105:	75 a1                	jne    801050a8 <procdump+0x18>
      getcallerpcs((uint *)p->context->ebp + 2, pc);
80105107:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010510a:	83 ec 08             	sub    $0x8,%esp
8010510d:	8d 7d c0             	lea    -0x40(%ebp),%edi
80105110:	50                   	push   %eax
80105111:	8b 43 1c             	mov    0x1c(%ebx),%eax
80105114:	8b 40 0c             	mov    0xc(%eax),%eax
80105117:	83 c0 08             	add    $0x8,%eax
8010511a:	50                   	push   %eax
8010511b:	e8 d0 03 00 00       	call   801054f0 <getcallerpcs>
80105120:	83 c4 10             	add    $0x10,%esp
80105123:	90                   	nop
80105124:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      for (i = 0; i < 10 && pc[i] != 0; i++)
80105128:	8b 17                	mov    (%edi),%edx
8010512a:	85 d2                	test   %edx,%edx
8010512c:	0f 84 76 ff ff ff    	je     801050a8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80105132:	83 ec 08             	sub    $0x8,%esp
80105135:	83 c7 04             	add    $0x4,%edi
80105138:	52                   	push   %edx
80105139:	68 41 83 10 80       	push   $0x80108341
8010513e:	e8 1d b5 ff ff       	call   80100660 <cprintf>
      for (i = 0; i < 10 && pc[i] != 0; i++)
80105143:	83 c4 10             	add    $0x10,%esp
80105146:	39 fe                	cmp    %edi,%esi
80105148:	75 de                	jne    80105128 <procdump+0x98>
8010514a:	e9 59 ff ff ff       	jmp    801050a8 <procdump+0x18>
8010514f:	90                   	nop
  }
}
80105150:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105153:	5b                   	pop    %ebx
80105154:	5e                   	pop    %esi
80105155:	5f                   	pop    %edi
80105156:	5d                   	pop    %ebp
80105157:	c3                   	ret    
80105158:	90                   	nop
80105159:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105160 <getpinfo>:

//*********************************** MY EDIT **********************************

int getpinfo(struct proc_stat *p_proc, int pid)
{
80105160:	55                   	push   %ebp
80105161:	89 e5                	mov    %esp,%ebp
80105163:	57                   	push   %edi
80105164:	56                   	push   %esi
80105165:	53                   	push   %ebx
80105166:	81 ec d8 00 00 00    	sub    $0xd8,%esp
8010516c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  int i = 0;
  acquire(&ptable.lock);
8010516f:	68 40 51 11 80       	push   $0x80115140
80105174:	e8 97 04 00 00       	call   80105610 <acquire>
80105179:	b8 74 51 11 80       	mov    $0x80115174,%eax
8010517e:	83 c4 10             	add    $0x10,%esp
80105181:	8d 95 2c ff ff ff    	lea    -0xd4(%ebp),%edx
80105187:	eb 13                	jmp    8010519c <getpinfo+0x3c>
80105189:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105190:	05 bc 00 00 00       	add    $0xbc,%eax

  for (i = 0; i < NPROC; ++i)
80105195:	3d 74 80 11 80       	cmp    $0x80118074,%eax
8010519a:	74 6c                	je     80105208 <getpinfo+0xa8>
  {
    struct proc p = ptable.proc[i];

    if (p.pid == pid)
8010519c:	3b 58 10             	cmp    0x10(%eax),%ebx
    struct proc p = ptable.proc[i];
8010519f:	b9 2f 00 00 00       	mov    $0x2f,%ecx
801051a4:	89 d7                	mov    %edx,%edi
801051a6:	89 c6                	mov    %eax,%esi
801051a8:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
    if (p.pid == pid)
801051aa:	75 e4                	jne    80105190 <getpinfo+0x30>
    struct proc p = ptable.proc[i];
801051ac:	8b 88 84 00 00 00    	mov    0x84(%eax),%ecx
801051b2:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
      p_proc->runtime = p.rtime;
      p_proc->num_run = p.num_run;
      p_proc->current_queue = p.current_queue; 
      for (int i = 0; i < 5; i++)              
        p_proc->ticks[i] = p.ticks[i];
      release(&ptable.lock);
801051b8:	83 ec 0c             	sub    $0xc,%esp
    struct proc p = ptable.proc[i];
801051bb:	8b 80 b8 00 00 00    	mov    0xb8(%eax),%eax
      p_proc->pid = p.pid;
801051c1:	8b 75 08             	mov    0x8(%ebp),%esi
      p_proc->current_queue = p.current_queue; 
801051c4:	89 46 0c             	mov    %eax,0xc(%esi)
        p_proc->ticks[i] = p.ticks[i];
801051c7:	8b 45 c0             	mov    -0x40(%ebp),%eax
      p_proc->pid = p.pid;
801051ca:	89 1e                	mov    %ebx,(%esi)
      p_proc->runtime = p.rtime;
801051cc:	89 4e 04             	mov    %ecx,0x4(%esi)
      p_proc->num_run = p.num_run;
801051cf:	89 56 08             	mov    %edx,0x8(%esi)
        p_proc->ticks[i] = p.ticks[i];
801051d2:	89 46 10             	mov    %eax,0x10(%esi)
801051d5:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801051d8:	89 46 14             	mov    %eax,0x14(%esi)
801051db:	8b 45 c8             	mov    -0x38(%ebp),%eax
801051de:	89 46 18             	mov    %eax,0x18(%esi)
801051e1:	8b 45 cc             	mov    -0x34(%ebp),%eax
801051e4:	89 46 1c             	mov    %eax,0x1c(%esi)
801051e7:	8b 45 d0             	mov    -0x30(%ebp),%eax
801051ea:	89 46 20             	mov    %eax,0x20(%esi)
      release(&ptable.lock);
801051ed:	68 40 51 11 80       	push   $0x80115140
801051f2:	e8 d9 04 00 00       	call   801056d0 <release>
      return pid;
801051f7:	83 c4 10             	add    $0x10,%esp
    }
  }
  release(&ptable.lock);
  return -1;
}
801051fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return pid;
801051fd:	89 d8                	mov    %ebx,%eax
}
801051ff:	5b                   	pop    %ebx
80105200:	5e                   	pop    %esi
80105201:	5f                   	pop    %edi
80105202:	5d                   	pop    %ebp
80105203:	c3                   	ret    
80105204:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80105208:	83 ec 0c             	sub    $0xc,%esp
8010520b:	68 40 51 11 80       	push   $0x80115140
80105210:	e8 bb 04 00 00       	call   801056d0 <release>
  return -1;
80105215:	83 c4 10             	add    $0x10,%esp
}
80105218:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010521b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105220:	5b                   	pop    %ebx
80105221:	5e                   	pop    %esi
80105222:	5f                   	pop    %edi
80105223:	5d                   	pop    %ebp
80105224:	c3                   	ret    
80105225:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105229:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105230 <ps>:

//************************************** MY EDIT (PS) *************************************
int ps()
{
80105230:	55                   	push   %ebp
80105231:	89 e5                	mov    %esp,%ebp
80105233:	53                   	push   %ebx
80105234:	83 ec 10             	sub    $0x10,%esp
  asm volatile("sti");
80105237:	fb                   	sti    

  //interrupt enabler
  sti();

  //looping over all processes
  acquire(&ptable.lock);
80105238:	68 40 51 11 80       	push   $0x80115140
  cprintf("name \t pid \t stat \t    priority \t   ctime \t  \n");

  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010523d:	bb 74 51 11 80       	mov    $0x80115174,%ebx
  acquire(&ptable.lock);
80105242:	e8 c9 03 00 00       	call   80105610 <acquire>
  cprintf("name \t pid \t stat \t    priority \t   ctime \t  \n");
80105247:	c7 04 24 6c 8c 10 80 	movl   $0x80108c6c,(%esp)
8010524e:	e8 0d b4 ff ff       	call   80100660 <cprintf>
80105253:	83 c4 10             	add    $0x10,%esp
80105256:	eb 24                	jmp    8010527c <ps+0x4c>
80105258:	90                   	nop
80105259:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  {
    if (p->state == SLEEPING)
      cprintf("%s \t %d \t SLEEPING \t %d \t %d \t \n", p->name, p->pid, p->priority, p->ctime);
    else if (p->state == RUNNING)
80105260:	83 f8 04             	cmp    $0x4,%eax
80105263:	74 6b                	je     801052d0 <ps+0xa0>
      cprintf("%s \t %d \t RUNNING \t %d \t %d \t \n", p->name, p->pid, p->priority, p->ctime);
    else if (p->state == RUNNABLE)
80105265:	83 f8 03             	cmp    $0x3,%eax
80105268:	0f 84 8a 00 00 00    	je     801052f8 <ps+0xc8>
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010526e:	81 c3 bc 00 00 00    	add    $0xbc,%ebx
80105274:	81 fb 74 80 11 80    	cmp    $0x80118074,%ebx
8010527a:	73 36                	jae    801052b2 <ps+0x82>
    if (p->state == SLEEPING)
8010527c:	8b 43 0c             	mov    0xc(%ebx),%eax
8010527f:	83 f8 02             	cmp    $0x2,%eax
80105282:	75 dc                	jne    80105260 <ps+0x30>
      cprintf("%s \t %d \t SLEEPING \t %d \t %d \t \n", p->name, p->pid, p->priority, p->ctime);
80105284:	8d 43 6c             	lea    0x6c(%ebx),%eax
80105287:	83 ec 0c             	sub    $0xc,%esp
8010528a:	ff 73 7c             	pushl  0x7c(%ebx)
8010528d:	ff b3 90 00 00 00    	pushl  0x90(%ebx)
80105293:	ff 73 10             	pushl  0x10(%ebx)
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80105296:	81 c3 bc 00 00 00    	add    $0xbc,%ebx
      cprintf("%s \t %d \t SLEEPING \t %d \t %d \t \n", p->name, p->pid, p->priority, p->ctime);
8010529c:	50                   	push   %eax
8010529d:	68 9c 8c 10 80       	push   $0x80108c9c
801052a2:	e8 b9 b3 ff ff       	call   80100660 <cprintf>
801052a7:	83 c4 20             	add    $0x20,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801052aa:	81 fb 74 80 11 80    	cmp    $0x80118074,%ebx
801052b0:	72 ca                	jb     8010527c <ps+0x4c>
      cprintf("%s \t %d \t RUNNABLE \t %d \t %d \t \n", p->name, p->pid, p->priority, p->ctime);
  }
  release(&ptable.lock);
801052b2:	83 ec 0c             	sub    $0xc,%esp
801052b5:	68 40 51 11 80       	push   $0x80115140
801052ba:	e8 11 04 00 00       	call   801056d0 <release>
  return 24;
}
801052bf:	b8 18 00 00 00       	mov    $0x18,%eax
801052c4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801052c7:	c9                   	leave  
801052c8:	c3                   	ret    
801052c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      cprintf("%s \t %d \t RUNNING \t %d \t %d \t \n", p->name, p->pid, p->priority, p->ctime);
801052d0:	8d 43 6c             	lea    0x6c(%ebx),%eax
801052d3:	83 ec 0c             	sub    $0xc,%esp
801052d6:	ff 73 7c             	pushl  0x7c(%ebx)
801052d9:	ff b3 90 00 00 00    	pushl  0x90(%ebx)
801052df:	ff 73 10             	pushl  0x10(%ebx)
801052e2:	50                   	push   %eax
801052e3:	68 c0 8c 10 80       	push   $0x80108cc0
801052e8:	e8 73 b3 ff ff       	call   80100660 <cprintf>
801052ed:	83 c4 20             	add    $0x20,%esp
801052f0:	e9 79 ff ff ff       	jmp    8010526e <ps+0x3e>
801052f5:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("%s \t %d \t RUNNABLE \t %d \t %d \t \n", p->name, p->pid, p->priority, p->ctime);
801052f8:	8d 43 6c             	lea    0x6c(%ebx),%eax
801052fb:	83 ec 0c             	sub    $0xc,%esp
801052fe:	ff 73 7c             	pushl  0x7c(%ebx)
80105301:	ff b3 90 00 00 00    	pushl  0x90(%ebx)
80105307:	ff 73 10             	pushl  0x10(%ebx)
8010530a:	50                   	push   %eax
8010530b:	68 e0 8c 10 80       	push   $0x80108ce0
80105310:	e8 4b b3 ff ff       	call   80100660 <cprintf>
80105315:	83 c4 20             	add    $0x20,%esp
80105318:	e9 51 ff ff ff       	jmp    8010526e <ps+0x3e>
8010531d:	8d 76 00             	lea    0x0(%esi),%esi

80105320 <set_priority>:

int set_priority(int pid, int priority)
{
80105320:	55                   	push   %ebp
80105321:	89 e5                	mov    %esp,%ebp
80105323:	53                   	push   %ebx
80105324:	83 ec 10             	sub    $0x10,%esp
80105327:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010532a:	fb                   	sti    
  //interrupt enabler
  sti();

  //looping over all processes
  int flag = 0;
  acquire(&ptable.lock);
8010532b:	68 40 51 11 80       	push   $0x80115140
80105330:	e8 db 02 00 00       	call   80105610 <acquire>
80105335:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80105338:	b8 74 51 11 80       	mov    $0x80115174,%eax
8010533d:	eb 0d                	jmp    8010534c <set_priority+0x2c>
8010533f:	90                   	nop
80105340:	05 bc 00 00 00       	add    $0xbc,%eax
80105345:	3d 74 80 11 80       	cmp    $0x80118074,%eax
8010534a:	73 2c                	jae    80105378 <set_priority+0x58>
  {
    if (p->pid == pid)
8010534c:	39 58 10             	cmp    %ebx,0x10(%eax)
8010534f:	75 ef                	jne    80105340 <set_priority+0x20>
    {
      p->priority = priority;
80105351:	8b 55 0c             	mov    0xc(%ebp),%edx
      flag = 1;
      break;
    }
  }
  release(&ptable.lock);
80105354:	83 ec 0c             	sub    $0xc,%esp
      p->priority = priority;
80105357:	89 90 90 00 00 00    	mov    %edx,0x90(%eax)
  release(&ptable.lock);
8010535d:	68 40 51 11 80       	push   $0x80115140
80105362:	e8 69 03 00 00       	call   801056d0 <release>
80105367:	83 c4 10             	add    $0x10,%esp

  if (flag != 0)
    return 24;
8010536a:	b8 18 00 00 00       	mov    $0x18,%eax
  else
    return -1;
}
8010536f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105372:	c9                   	leave  
80105373:	c3                   	ret    
80105374:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80105378:	83 ec 0c             	sub    $0xc,%esp
8010537b:	68 40 51 11 80       	push   $0x80115140
80105380:	e8 4b 03 00 00       	call   801056d0 <release>
    return -1;
80105385:	83 c4 10             	add    $0x10,%esp
80105388:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010538d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105390:	c9                   	leave  
80105391:	c3                   	ret    
80105392:	66 90                	xchg   %ax,%ax
80105394:	66 90                	xchg   %ax,%ax
80105396:	66 90                	xchg   %ax,%ax
80105398:	66 90                	xchg   %ax,%ax
8010539a:	66 90                	xchg   %ax,%ax
8010539c:	66 90                	xchg   %ax,%ax
8010539e:	66 90                	xchg   %ax,%ax

801053a0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801053a0:	55                   	push   %ebp
801053a1:	89 e5                	mov    %esp,%ebp
801053a3:	53                   	push   %ebx
801053a4:	83 ec 0c             	sub    $0xc,%esp
801053a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801053aa:	68 1c 8d 10 80       	push   $0x80108d1c
801053af:	8d 43 04             	lea    0x4(%ebx),%eax
801053b2:	50                   	push   %eax
801053b3:	e8 18 01 00 00       	call   801054d0 <initlock>
  lk->name = name;
801053b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
801053bb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
801053c1:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
801053c4:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
801053cb:	89 43 38             	mov    %eax,0x38(%ebx)
}
801053ce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801053d1:	c9                   	leave  
801053d2:	c3                   	ret    
801053d3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801053d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801053e0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
801053e0:	55                   	push   %ebp
801053e1:	89 e5                	mov    %esp,%ebp
801053e3:	56                   	push   %esi
801053e4:	53                   	push   %ebx
801053e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801053e8:	83 ec 0c             	sub    $0xc,%esp
801053eb:	8d 73 04             	lea    0x4(%ebx),%esi
801053ee:	56                   	push   %esi
801053ef:	e8 1c 02 00 00       	call   80105610 <acquire>
  while (lk->locked) {
801053f4:	8b 13                	mov    (%ebx),%edx
801053f6:	83 c4 10             	add    $0x10,%esp
801053f9:	85 d2                	test   %edx,%edx
801053fb:	74 16                	je     80105413 <acquiresleep+0x33>
801053fd:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80105400:	83 ec 08             	sub    $0x8,%esp
80105403:	56                   	push   %esi
80105404:	53                   	push   %ebx
80105405:	e8 86 f8 ff ff       	call   80104c90 <sleep>
  while (lk->locked) {
8010540a:	8b 03                	mov    (%ebx),%eax
8010540c:	83 c4 10             	add    $0x10,%esp
8010540f:	85 c0                	test   %eax,%eax
80105411:	75 ed                	jne    80105400 <acquiresleep+0x20>
  }
  lk->locked = 1;
80105413:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80105419:	e8 82 e4 ff ff       	call   801038a0 <myproc>
8010541e:	8b 40 10             	mov    0x10(%eax),%eax
80105421:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80105424:	89 75 08             	mov    %esi,0x8(%ebp)
}
80105427:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010542a:	5b                   	pop    %ebx
8010542b:	5e                   	pop    %esi
8010542c:	5d                   	pop    %ebp
  release(&lk->lk);
8010542d:	e9 9e 02 00 00       	jmp    801056d0 <release>
80105432:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105439:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105440 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80105440:	55                   	push   %ebp
80105441:	89 e5                	mov    %esp,%ebp
80105443:	56                   	push   %esi
80105444:	53                   	push   %ebx
80105445:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80105448:	83 ec 0c             	sub    $0xc,%esp
8010544b:	8d 73 04             	lea    0x4(%ebx),%esi
8010544e:	56                   	push   %esi
8010544f:	e8 bc 01 00 00       	call   80105610 <acquire>
  lk->locked = 0;
80105454:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010545a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80105461:	89 1c 24             	mov    %ebx,(%esp)
80105464:	e8 47 fb ff ff       	call   80104fb0 <wakeup>
  release(&lk->lk);
80105469:	89 75 08             	mov    %esi,0x8(%ebp)
8010546c:	83 c4 10             	add    $0x10,%esp
}
8010546f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105472:	5b                   	pop    %ebx
80105473:	5e                   	pop    %esi
80105474:	5d                   	pop    %ebp
  release(&lk->lk);
80105475:	e9 56 02 00 00       	jmp    801056d0 <release>
8010547a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105480 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80105480:	55                   	push   %ebp
80105481:	89 e5                	mov    %esp,%ebp
80105483:	57                   	push   %edi
80105484:	56                   	push   %esi
80105485:	53                   	push   %ebx
80105486:	31 ff                	xor    %edi,%edi
80105488:	83 ec 18             	sub    $0x18,%esp
8010548b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
8010548e:	8d 73 04             	lea    0x4(%ebx),%esi
80105491:	56                   	push   %esi
80105492:	e8 79 01 00 00       	call   80105610 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80105497:	8b 03                	mov    (%ebx),%eax
80105499:	83 c4 10             	add    $0x10,%esp
8010549c:	85 c0                	test   %eax,%eax
8010549e:	74 13                	je     801054b3 <holdingsleep+0x33>
801054a0:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
801054a3:	e8 f8 e3 ff ff       	call   801038a0 <myproc>
801054a8:	39 58 10             	cmp    %ebx,0x10(%eax)
801054ab:	0f 94 c0             	sete   %al
801054ae:	0f b6 c0             	movzbl %al,%eax
801054b1:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
801054b3:	83 ec 0c             	sub    $0xc,%esp
801054b6:	56                   	push   %esi
801054b7:	e8 14 02 00 00       	call   801056d0 <release>
  return r;
}
801054bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801054bf:	89 f8                	mov    %edi,%eax
801054c1:	5b                   	pop    %ebx
801054c2:	5e                   	pop    %esi
801054c3:	5f                   	pop    %edi
801054c4:	5d                   	pop    %ebp
801054c5:	c3                   	ret    
801054c6:	66 90                	xchg   %ax,%ax
801054c8:	66 90                	xchg   %ax,%ax
801054ca:	66 90                	xchg   %ax,%ax
801054cc:	66 90                	xchg   %ax,%ax
801054ce:	66 90                	xchg   %ax,%ax

801054d0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801054d0:	55                   	push   %ebp
801054d1:	89 e5                	mov    %esp,%ebp
801054d3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
801054d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
801054d9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
801054df:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
801054e2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801054e9:	5d                   	pop    %ebp
801054ea:	c3                   	ret    
801054eb:	90                   	nop
801054ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801054f0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801054f0:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801054f1:	31 d2                	xor    %edx,%edx
{
801054f3:	89 e5                	mov    %esp,%ebp
801054f5:	53                   	push   %ebx
  ebp = (uint*)v - 2;
801054f6:	8b 45 08             	mov    0x8(%ebp),%eax
{
801054f9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
801054fc:	83 e8 08             	sub    $0x8,%eax
801054ff:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105500:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80105506:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010550c:	77 1a                	ja     80105528 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010550e:	8b 58 04             	mov    0x4(%eax),%ebx
80105511:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80105514:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80105517:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80105519:	83 fa 0a             	cmp    $0xa,%edx
8010551c:	75 e2                	jne    80105500 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010551e:	5b                   	pop    %ebx
8010551f:	5d                   	pop    %ebp
80105520:	c3                   	ret    
80105521:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105528:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010552b:	83 c1 28             	add    $0x28,%ecx
8010552e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80105530:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80105536:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80105539:	39 c1                	cmp    %eax,%ecx
8010553b:	75 f3                	jne    80105530 <getcallerpcs+0x40>
}
8010553d:	5b                   	pop    %ebx
8010553e:	5d                   	pop    %ebp
8010553f:	c3                   	ret    

80105540 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80105540:	55                   	push   %ebp
80105541:	89 e5                	mov    %esp,%ebp
80105543:	53                   	push   %ebx
80105544:	83 ec 04             	sub    $0x4,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80105547:	9c                   	pushf  
80105548:	5b                   	pop    %ebx
  asm volatile("cli");
80105549:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010554a:	e8 b1 e2 ff ff       	call   80103800 <mycpu>
8010554f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80105555:	85 c0                	test   %eax,%eax
80105557:	75 11                	jne    8010556a <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80105559:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010555f:	e8 9c e2 ff ff       	call   80103800 <mycpu>
80105564:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
8010556a:	e8 91 e2 ff ff       	call   80103800 <mycpu>
8010556f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80105576:	83 c4 04             	add    $0x4,%esp
80105579:	5b                   	pop    %ebx
8010557a:	5d                   	pop    %ebp
8010557b:	c3                   	ret    
8010557c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105580 <popcli>:

void
popcli(void)
{
80105580:	55                   	push   %ebp
80105581:	89 e5                	mov    %esp,%ebp
80105583:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80105586:	9c                   	pushf  
80105587:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80105588:	f6 c4 02             	test   $0x2,%ah
8010558b:	75 35                	jne    801055c2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010558d:	e8 6e e2 ff ff       	call   80103800 <mycpu>
80105592:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80105599:	78 34                	js     801055cf <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010559b:	e8 60 e2 ff ff       	call   80103800 <mycpu>
801055a0:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801055a6:	85 d2                	test   %edx,%edx
801055a8:	74 06                	je     801055b0 <popcli+0x30>
    sti();
}
801055aa:	c9                   	leave  
801055ab:	c3                   	ret    
801055ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
801055b0:	e8 4b e2 ff ff       	call   80103800 <mycpu>
801055b5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801055bb:	85 c0                	test   %eax,%eax
801055bd:	74 eb                	je     801055aa <popcli+0x2a>
  asm volatile("sti");
801055bf:	fb                   	sti    
}
801055c0:	c9                   	leave  
801055c1:	c3                   	ret    
    panic("popcli - interruptible");
801055c2:	83 ec 0c             	sub    $0xc,%esp
801055c5:	68 27 8d 10 80       	push   $0x80108d27
801055ca:	e8 c1 ad ff ff       	call   80100390 <panic>
    panic("popcli");
801055cf:	83 ec 0c             	sub    $0xc,%esp
801055d2:	68 3e 8d 10 80       	push   $0x80108d3e
801055d7:	e8 b4 ad ff ff       	call   80100390 <panic>
801055dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801055e0 <holding>:
{
801055e0:	55                   	push   %ebp
801055e1:	89 e5                	mov    %esp,%ebp
801055e3:	56                   	push   %esi
801055e4:	53                   	push   %ebx
801055e5:	8b 75 08             	mov    0x8(%ebp),%esi
801055e8:	31 db                	xor    %ebx,%ebx
  pushcli();
801055ea:	e8 51 ff ff ff       	call   80105540 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801055ef:	8b 06                	mov    (%esi),%eax
801055f1:	85 c0                	test   %eax,%eax
801055f3:	74 10                	je     80105605 <holding+0x25>
801055f5:	8b 5e 08             	mov    0x8(%esi),%ebx
801055f8:	e8 03 e2 ff ff       	call   80103800 <mycpu>
801055fd:	39 c3                	cmp    %eax,%ebx
801055ff:	0f 94 c3             	sete   %bl
80105602:	0f b6 db             	movzbl %bl,%ebx
  popcli();
80105605:	e8 76 ff ff ff       	call   80105580 <popcli>
}
8010560a:	89 d8                	mov    %ebx,%eax
8010560c:	5b                   	pop    %ebx
8010560d:	5e                   	pop    %esi
8010560e:	5d                   	pop    %ebp
8010560f:	c3                   	ret    

80105610 <acquire>:
{
80105610:	55                   	push   %ebp
80105611:	89 e5                	mov    %esp,%ebp
80105613:	56                   	push   %esi
80105614:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80105615:	e8 26 ff ff ff       	call   80105540 <pushcli>
  if(holding(lk))
8010561a:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010561d:	83 ec 0c             	sub    $0xc,%esp
80105620:	53                   	push   %ebx
80105621:	e8 ba ff ff ff       	call   801055e0 <holding>
80105626:	83 c4 10             	add    $0x10,%esp
80105629:	85 c0                	test   %eax,%eax
8010562b:	0f 85 83 00 00 00    	jne    801056b4 <acquire+0xa4>
80105631:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80105633:	ba 01 00 00 00       	mov    $0x1,%edx
80105638:	eb 09                	jmp    80105643 <acquire+0x33>
8010563a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105640:	8b 5d 08             	mov    0x8(%ebp),%ebx
80105643:	89 d0                	mov    %edx,%eax
80105645:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80105648:	85 c0                	test   %eax,%eax
8010564a:	75 f4                	jne    80105640 <acquire+0x30>
  __sync_synchronize();
8010564c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80105651:	8b 5d 08             	mov    0x8(%ebp),%ebx
80105654:	e8 a7 e1 ff ff       	call   80103800 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80105659:	8d 53 0c             	lea    0xc(%ebx),%edx
  lk->cpu = mycpu();
8010565c:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
8010565f:	89 e8                	mov    %ebp,%eax
80105661:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105668:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
8010566e:	81 f9 fe ff ff 7f    	cmp    $0x7ffffffe,%ecx
80105674:	77 1a                	ja     80105690 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
80105676:	8b 48 04             	mov    0x4(%eax),%ecx
80105679:	89 0c b2             	mov    %ecx,(%edx,%esi,4)
  for(i = 0; i < 10; i++){
8010567c:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
8010567f:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80105681:	83 fe 0a             	cmp    $0xa,%esi
80105684:	75 e2                	jne    80105668 <acquire+0x58>
}
80105686:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105689:	5b                   	pop    %ebx
8010568a:	5e                   	pop    %esi
8010568b:	5d                   	pop    %ebp
8010568c:	c3                   	ret    
8010568d:	8d 76 00             	lea    0x0(%esi),%esi
80105690:	8d 04 b2             	lea    (%edx,%esi,4),%eax
80105693:	83 c2 28             	add    $0x28,%edx
80105696:	8d 76 00             	lea    0x0(%esi),%esi
80105699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pcs[i] = 0;
801056a0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
801056a6:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
801056a9:	39 d0                	cmp    %edx,%eax
801056ab:	75 f3                	jne    801056a0 <acquire+0x90>
}
801056ad:	8d 65 f8             	lea    -0x8(%ebp),%esp
801056b0:	5b                   	pop    %ebx
801056b1:	5e                   	pop    %esi
801056b2:	5d                   	pop    %ebp
801056b3:	c3                   	ret    
    panic("acquire");
801056b4:	83 ec 0c             	sub    $0xc,%esp
801056b7:	68 45 8d 10 80       	push   $0x80108d45
801056bc:	e8 cf ac ff ff       	call   80100390 <panic>
801056c1:	eb 0d                	jmp    801056d0 <release>
801056c3:	90                   	nop
801056c4:	90                   	nop
801056c5:	90                   	nop
801056c6:	90                   	nop
801056c7:	90                   	nop
801056c8:	90                   	nop
801056c9:	90                   	nop
801056ca:	90                   	nop
801056cb:	90                   	nop
801056cc:	90                   	nop
801056cd:	90                   	nop
801056ce:	90                   	nop
801056cf:	90                   	nop

801056d0 <release>:
{
801056d0:	55                   	push   %ebp
801056d1:	89 e5                	mov    %esp,%ebp
801056d3:	53                   	push   %ebx
801056d4:	83 ec 10             	sub    $0x10,%esp
801056d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
801056da:	53                   	push   %ebx
801056db:	e8 00 ff ff ff       	call   801055e0 <holding>
801056e0:	83 c4 10             	add    $0x10,%esp
801056e3:	85 c0                	test   %eax,%eax
801056e5:	74 22                	je     80105709 <release+0x39>
  lk->pcs[0] = 0;
801056e7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
801056ee:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
801056f5:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801056fa:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80105700:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105703:	c9                   	leave  
  popcli();
80105704:	e9 77 fe ff ff       	jmp    80105580 <popcli>
    panic("release");
80105709:	83 ec 0c             	sub    $0xc,%esp
8010570c:	68 4d 8d 10 80       	push   $0x80108d4d
80105711:	e8 7a ac ff ff       	call   80100390 <panic>
80105716:	66 90                	xchg   %ax,%ax
80105718:	66 90                	xchg   %ax,%ax
8010571a:	66 90                	xchg   %ax,%ax
8010571c:	66 90                	xchg   %ax,%ax
8010571e:	66 90                	xchg   %ax,%ax

80105720 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80105720:	55                   	push   %ebp
80105721:	89 e5                	mov    %esp,%ebp
80105723:	57                   	push   %edi
80105724:	53                   	push   %ebx
80105725:	8b 55 08             	mov    0x8(%ebp),%edx
80105728:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
8010572b:	f6 c2 03             	test   $0x3,%dl
8010572e:	75 05                	jne    80105735 <memset+0x15>
80105730:	f6 c1 03             	test   $0x3,%cl
80105733:	74 13                	je     80105748 <memset+0x28>
  asm volatile("cld; rep stosb" :
80105735:	89 d7                	mov    %edx,%edi
80105737:	8b 45 0c             	mov    0xc(%ebp),%eax
8010573a:	fc                   	cld    
8010573b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
8010573d:	5b                   	pop    %ebx
8010573e:	89 d0                	mov    %edx,%eax
80105740:	5f                   	pop    %edi
80105741:	5d                   	pop    %ebp
80105742:	c3                   	ret    
80105743:	90                   	nop
80105744:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
80105748:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010574c:	c1 e9 02             	shr    $0x2,%ecx
8010574f:	89 f8                	mov    %edi,%eax
80105751:	89 fb                	mov    %edi,%ebx
80105753:	c1 e0 18             	shl    $0x18,%eax
80105756:	c1 e3 10             	shl    $0x10,%ebx
80105759:	09 d8                	or     %ebx,%eax
8010575b:	09 f8                	or     %edi,%eax
8010575d:	c1 e7 08             	shl    $0x8,%edi
80105760:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80105762:	89 d7                	mov    %edx,%edi
80105764:	fc                   	cld    
80105765:	f3 ab                	rep stos %eax,%es:(%edi)
}
80105767:	5b                   	pop    %ebx
80105768:	89 d0                	mov    %edx,%eax
8010576a:	5f                   	pop    %edi
8010576b:	5d                   	pop    %ebp
8010576c:	c3                   	ret    
8010576d:	8d 76 00             	lea    0x0(%esi),%esi

80105770 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80105770:	55                   	push   %ebp
80105771:	89 e5                	mov    %esp,%ebp
80105773:	57                   	push   %edi
80105774:	56                   	push   %esi
80105775:	53                   	push   %ebx
80105776:	8b 5d 10             	mov    0x10(%ebp),%ebx
80105779:	8b 75 08             	mov    0x8(%ebp),%esi
8010577c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010577f:	85 db                	test   %ebx,%ebx
80105781:	74 29                	je     801057ac <memcmp+0x3c>
    if(*s1 != *s2)
80105783:	0f b6 16             	movzbl (%esi),%edx
80105786:	0f b6 0f             	movzbl (%edi),%ecx
80105789:	38 d1                	cmp    %dl,%cl
8010578b:	75 2b                	jne    801057b8 <memcmp+0x48>
8010578d:	b8 01 00 00 00       	mov    $0x1,%eax
80105792:	eb 14                	jmp    801057a8 <memcmp+0x38>
80105794:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105798:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
8010579c:	83 c0 01             	add    $0x1,%eax
8010579f:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
801057a4:	38 ca                	cmp    %cl,%dl
801057a6:	75 10                	jne    801057b8 <memcmp+0x48>
  while(n-- > 0){
801057a8:	39 d8                	cmp    %ebx,%eax
801057aa:	75 ec                	jne    80105798 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
801057ac:	5b                   	pop    %ebx
  return 0;
801057ad:	31 c0                	xor    %eax,%eax
}
801057af:	5e                   	pop    %esi
801057b0:	5f                   	pop    %edi
801057b1:	5d                   	pop    %ebp
801057b2:	c3                   	ret    
801057b3:	90                   	nop
801057b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return *s1 - *s2;
801057b8:	0f b6 c2             	movzbl %dl,%eax
}
801057bb:	5b                   	pop    %ebx
      return *s1 - *s2;
801057bc:	29 c8                	sub    %ecx,%eax
}
801057be:	5e                   	pop    %esi
801057bf:	5f                   	pop    %edi
801057c0:	5d                   	pop    %ebp
801057c1:	c3                   	ret    
801057c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801057d0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801057d0:	55                   	push   %ebp
801057d1:	89 e5                	mov    %esp,%ebp
801057d3:	56                   	push   %esi
801057d4:	53                   	push   %ebx
801057d5:	8b 45 08             	mov    0x8(%ebp),%eax
801057d8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801057db:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801057de:	39 c3                	cmp    %eax,%ebx
801057e0:	73 26                	jae    80105808 <memmove+0x38>
801057e2:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
801057e5:	39 c8                	cmp    %ecx,%eax
801057e7:	73 1f                	jae    80105808 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
801057e9:	85 f6                	test   %esi,%esi
801057eb:	8d 56 ff             	lea    -0x1(%esi),%edx
801057ee:	74 0f                	je     801057ff <memmove+0x2f>
      *--d = *--s;
801057f0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
801057f4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
801057f7:	83 ea 01             	sub    $0x1,%edx
801057fa:	83 fa ff             	cmp    $0xffffffff,%edx
801057fd:	75 f1                	jne    801057f0 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
801057ff:	5b                   	pop    %ebx
80105800:	5e                   	pop    %esi
80105801:	5d                   	pop    %ebp
80105802:	c3                   	ret    
80105803:	90                   	nop
80105804:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
80105808:	31 d2                	xor    %edx,%edx
8010580a:	85 f6                	test   %esi,%esi
8010580c:	74 f1                	je     801057ff <memmove+0x2f>
8010580e:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80105810:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80105814:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80105817:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
8010581a:	39 d6                	cmp    %edx,%esi
8010581c:	75 f2                	jne    80105810 <memmove+0x40>
}
8010581e:	5b                   	pop    %ebx
8010581f:	5e                   	pop    %esi
80105820:	5d                   	pop    %ebp
80105821:	c3                   	ret    
80105822:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105829:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105830 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80105830:	55                   	push   %ebp
80105831:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80105833:	5d                   	pop    %ebp
  return memmove(dst, src, n);
80105834:	eb 9a                	jmp    801057d0 <memmove>
80105836:	8d 76 00             	lea    0x0(%esi),%esi
80105839:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105840 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80105840:	55                   	push   %ebp
80105841:	89 e5                	mov    %esp,%ebp
80105843:	57                   	push   %edi
80105844:	56                   	push   %esi
80105845:	8b 7d 10             	mov    0x10(%ebp),%edi
80105848:	53                   	push   %ebx
80105849:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010584c:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
8010584f:	85 ff                	test   %edi,%edi
80105851:	74 2f                	je     80105882 <strncmp+0x42>
80105853:	0f b6 01             	movzbl (%ecx),%eax
80105856:	0f b6 1e             	movzbl (%esi),%ebx
80105859:	84 c0                	test   %al,%al
8010585b:	74 37                	je     80105894 <strncmp+0x54>
8010585d:	38 c3                	cmp    %al,%bl
8010585f:	75 33                	jne    80105894 <strncmp+0x54>
80105861:	01 f7                	add    %esi,%edi
80105863:	eb 13                	jmp    80105878 <strncmp+0x38>
80105865:	8d 76 00             	lea    0x0(%esi),%esi
80105868:	0f b6 01             	movzbl (%ecx),%eax
8010586b:	84 c0                	test   %al,%al
8010586d:	74 21                	je     80105890 <strncmp+0x50>
8010586f:	0f b6 1a             	movzbl (%edx),%ebx
80105872:	89 d6                	mov    %edx,%esi
80105874:	38 d8                	cmp    %bl,%al
80105876:	75 1c                	jne    80105894 <strncmp+0x54>
    n--, p++, q++;
80105878:	8d 56 01             	lea    0x1(%esi),%edx
8010587b:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
8010587e:	39 fa                	cmp    %edi,%edx
80105880:	75 e6                	jne    80105868 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80105882:	5b                   	pop    %ebx
    return 0;
80105883:	31 c0                	xor    %eax,%eax
}
80105885:	5e                   	pop    %esi
80105886:	5f                   	pop    %edi
80105887:	5d                   	pop    %ebp
80105888:	c3                   	ret    
80105889:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105890:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
80105894:	29 d8                	sub    %ebx,%eax
}
80105896:	5b                   	pop    %ebx
80105897:	5e                   	pop    %esi
80105898:	5f                   	pop    %edi
80105899:	5d                   	pop    %ebp
8010589a:	c3                   	ret    
8010589b:	90                   	nop
8010589c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801058a0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801058a0:	55                   	push   %ebp
801058a1:	89 e5                	mov    %esp,%ebp
801058a3:	56                   	push   %esi
801058a4:	53                   	push   %ebx
801058a5:	8b 45 08             	mov    0x8(%ebp),%eax
801058a8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801058ab:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
801058ae:	89 c2                	mov    %eax,%edx
801058b0:	eb 19                	jmp    801058cb <strncpy+0x2b>
801058b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801058b8:	83 c3 01             	add    $0x1,%ebx
801058bb:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
801058bf:	83 c2 01             	add    $0x1,%edx
801058c2:	84 c9                	test   %cl,%cl
801058c4:	88 4a ff             	mov    %cl,-0x1(%edx)
801058c7:	74 09                	je     801058d2 <strncpy+0x32>
801058c9:	89 f1                	mov    %esi,%ecx
801058cb:	85 c9                	test   %ecx,%ecx
801058cd:	8d 71 ff             	lea    -0x1(%ecx),%esi
801058d0:	7f e6                	jg     801058b8 <strncpy+0x18>
    ;
  while(n-- > 0)
801058d2:	31 c9                	xor    %ecx,%ecx
801058d4:	85 f6                	test   %esi,%esi
801058d6:	7e 17                	jle    801058ef <strncpy+0x4f>
801058d8:	90                   	nop
801058d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
801058e0:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
801058e4:	89 f3                	mov    %esi,%ebx
801058e6:	83 c1 01             	add    $0x1,%ecx
801058e9:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
801058eb:	85 db                	test   %ebx,%ebx
801058ed:	7f f1                	jg     801058e0 <strncpy+0x40>
  return os;
}
801058ef:	5b                   	pop    %ebx
801058f0:	5e                   	pop    %esi
801058f1:	5d                   	pop    %ebp
801058f2:	c3                   	ret    
801058f3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801058f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105900 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105900:	55                   	push   %ebp
80105901:	89 e5                	mov    %esp,%ebp
80105903:	56                   	push   %esi
80105904:	53                   	push   %ebx
80105905:	8b 4d 10             	mov    0x10(%ebp),%ecx
80105908:	8b 45 08             	mov    0x8(%ebp),%eax
8010590b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
8010590e:	85 c9                	test   %ecx,%ecx
80105910:	7e 26                	jle    80105938 <safestrcpy+0x38>
80105912:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80105916:	89 c1                	mov    %eax,%ecx
80105918:	eb 17                	jmp    80105931 <safestrcpy+0x31>
8010591a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80105920:	83 c2 01             	add    $0x1,%edx
80105923:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80105927:	83 c1 01             	add    $0x1,%ecx
8010592a:	84 db                	test   %bl,%bl
8010592c:	88 59 ff             	mov    %bl,-0x1(%ecx)
8010592f:	74 04                	je     80105935 <safestrcpy+0x35>
80105931:	39 f2                	cmp    %esi,%edx
80105933:	75 eb                	jne    80105920 <safestrcpy+0x20>
    ;
  *s = 0;
80105935:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80105938:	5b                   	pop    %ebx
80105939:	5e                   	pop    %esi
8010593a:	5d                   	pop    %ebp
8010593b:	c3                   	ret    
8010593c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105940 <strlen>:

int
strlen(const char *s)
{
80105940:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80105941:	31 c0                	xor    %eax,%eax
{
80105943:	89 e5                	mov    %esp,%ebp
80105945:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80105948:	80 3a 00             	cmpb   $0x0,(%edx)
8010594b:	74 0c                	je     80105959 <strlen+0x19>
8010594d:	8d 76 00             	lea    0x0(%esi),%esi
80105950:	83 c0 01             	add    $0x1,%eax
80105953:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80105957:	75 f7                	jne    80105950 <strlen+0x10>
    ;
  return n;
}
80105959:	5d                   	pop    %ebp
8010595a:	c3                   	ret    

8010595b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010595b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010595f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80105963:	55                   	push   %ebp
  pushl %ebx
80105964:	53                   	push   %ebx
  pushl %esi
80105965:	56                   	push   %esi
  pushl %edi
80105966:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80105967:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105969:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
8010596b:	5f                   	pop    %edi
  popl %esi
8010596c:	5e                   	pop    %esi
  popl %ebx
8010596d:	5b                   	pop    %ebx
  popl %ebp
8010596e:	5d                   	pop    %ebp
  ret
8010596f:	c3                   	ret    

80105970 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105970:	55                   	push   %ebp
80105971:	89 e5                	mov    %esp,%ebp
80105973:	53                   	push   %ebx
80105974:	83 ec 04             	sub    $0x4,%esp
80105977:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010597a:	e8 21 df ff ff       	call   801038a0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010597f:	8b 00                	mov    (%eax),%eax
80105981:	39 d8                	cmp    %ebx,%eax
80105983:	76 1b                	jbe    801059a0 <fetchint+0x30>
80105985:	8d 53 04             	lea    0x4(%ebx),%edx
80105988:	39 d0                	cmp    %edx,%eax
8010598a:	72 14                	jb     801059a0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
8010598c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010598f:	8b 13                	mov    (%ebx),%edx
80105991:	89 10                	mov    %edx,(%eax)
  return 0;
80105993:	31 c0                	xor    %eax,%eax
}
80105995:	83 c4 04             	add    $0x4,%esp
80105998:	5b                   	pop    %ebx
80105999:	5d                   	pop    %ebp
8010599a:	c3                   	ret    
8010599b:	90                   	nop
8010599c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801059a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059a5:	eb ee                	jmp    80105995 <fetchint+0x25>
801059a7:	89 f6                	mov    %esi,%esi
801059a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801059b0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
801059b0:	55                   	push   %ebp
801059b1:	89 e5                	mov    %esp,%ebp
801059b3:	53                   	push   %ebx
801059b4:	83 ec 04             	sub    $0x4,%esp
801059b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
801059ba:	e8 e1 de ff ff       	call   801038a0 <myproc>

  if(addr >= curproc->sz)
801059bf:	39 18                	cmp    %ebx,(%eax)
801059c1:	76 29                	jbe    801059ec <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
801059c3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801059c6:	89 da                	mov    %ebx,%edx
801059c8:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
801059ca:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
801059cc:	39 c3                	cmp    %eax,%ebx
801059ce:	73 1c                	jae    801059ec <fetchstr+0x3c>
    if(*s == 0)
801059d0:	80 3b 00             	cmpb   $0x0,(%ebx)
801059d3:	75 10                	jne    801059e5 <fetchstr+0x35>
801059d5:	eb 39                	jmp    80105a10 <fetchstr+0x60>
801059d7:	89 f6                	mov    %esi,%esi
801059d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801059e0:	80 3a 00             	cmpb   $0x0,(%edx)
801059e3:	74 1b                	je     80105a00 <fetchstr+0x50>
  for(s = *pp; s < ep; s++){
801059e5:	83 c2 01             	add    $0x1,%edx
801059e8:	39 d0                	cmp    %edx,%eax
801059ea:	77 f4                	ja     801059e0 <fetchstr+0x30>
    return -1;
801059ec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
801059f1:	83 c4 04             	add    $0x4,%esp
801059f4:	5b                   	pop    %ebx
801059f5:	5d                   	pop    %ebp
801059f6:	c3                   	ret    
801059f7:	89 f6                	mov    %esi,%esi
801059f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105a00:	83 c4 04             	add    $0x4,%esp
80105a03:	89 d0                	mov    %edx,%eax
80105a05:	29 d8                	sub    %ebx,%eax
80105a07:	5b                   	pop    %ebx
80105a08:	5d                   	pop    %ebp
80105a09:	c3                   	ret    
80105a0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s == 0)
80105a10:	31 c0                	xor    %eax,%eax
      return s - *pp;
80105a12:	eb dd                	jmp    801059f1 <fetchstr+0x41>
80105a14:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105a1a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105a20 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105a20:	55                   	push   %ebp
80105a21:	89 e5                	mov    %esp,%ebp
80105a23:	56                   	push   %esi
80105a24:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105a25:	e8 76 de ff ff       	call   801038a0 <myproc>
80105a2a:	8b 40 18             	mov    0x18(%eax),%eax
80105a2d:	8b 55 08             	mov    0x8(%ebp),%edx
80105a30:	8b 40 44             	mov    0x44(%eax),%eax
80105a33:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105a36:	e8 65 de ff ff       	call   801038a0 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105a3b:	8b 00                	mov    (%eax),%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105a3d:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105a40:	39 c6                	cmp    %eax,%esi
80105a42:	73 1c                	jae    80105a60 <argint+0x40>
80105a44:	8d 53 08             	lea    0x8(%ebx),%edx
80105a47:	39 d0                	cmp    %edx,%eax
80105a49:	72 15                	jb     80105a60 <argint+0x40>
  *ip = *(int*)(addr);
80105a4b:	8b 45 0c             	mov    0xc(%ebp),%eax
80105a4e:	8b 53 04             	mov    0x4(%ebx),%edx
80105a51:	89 10                	mov    %edx,(%eax)
  return 0;
80105a53:	31 c0                	xor    %eax,%eax
}
80105a55:	5b                   	pop    %ebx
80105a56:	5e                   	pop    %esi
80105a57:	5d                   	pop    %ebp
80105a58:	c3                   	ret    
80105a59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105a60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105a65:	eb ee                	jmp    80105a55 <argint+0x35>
80105a67:	89 f6                	mov    %esi,%esi
80105a69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105a70 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105a70:	55                   	push   %ebp
80105a71:	89 e5                	mov    %esp,%ebp
80105a73:	56                   	push   %esi
80105a74:	53                   	push   %ebx
80105a75:	83 ec 10             	sub    $0x10,%esp
80105a78:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80105a7b:	e8 20 de ff ff       	call   801038a0 <myproc>
80105a80:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80105a82:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a85:	83 ec 08             	sub    $0x8,%esp
80105a88:	50                   	push   %eax
80105a89:	ff 75 08             	pushl  0x8(%ebp)
80105a8c:	e8 8f ff ff ff       	call   80105a20 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80105a91:	83 c4 10             	add    $0x10,%esp
80105a94:	85 c0                	test   %eax,%eax
80105a96:	78 28                	js     80105ac0 <argptr+0x50>
80105a98:	85 db                	test   %ebx,%ebx
80105a9a:	78 24                	js     80105ac0 <argptr+0x50>
80105a9c:	8b 16                	mov    (%esi),%edx
80105a9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105aa1:	39 c2                	cmp    %eax,%edx
80105aa3:	76 1b                	jbe    80105ac0 <argptr+0x50>
80105aa5:	01 c3                	add    %eax,%ebx
80105aa7:	39 da                	cmp    %ebx,%edx
80105aa9:	72 15                	jb     80105ac0 <argptr+0x50>
    return -1;
  *pp = (char*)i;
80105aab:	8b 55 0c             	mov    0xc(%ebp),%edx
80105aae:	89 02                	mov    %eax,(%edx)
  return 0;
80105ab0:	31 c0                	xor    %eax,%eax
}
80105ab2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105ab5:	5b                   	pop    %ebx
80105ab6:	5e                   	pop    %esi
80105ab7:	5d                   	pop    %ebp
80105ab8:	c3                   	ret    
80105ab9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105ac0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ac5:	eb eb                	jmp    80105ab2 <argptr+0x42>
80105ac7:	89 f6                	mov    %esi,%esi
80105ac9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105ad0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105ad0:	55                   	push   %ebp
80105ad1:	89 e5                	mov    %esp,%ebp
80105ad3:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80105ad6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105ad9:	50                   	push   %eax
80105ada:	ff 75 08             	pushl  0x8(%ebp)
80105add:	e8 3e ff ff ff       	call   80105a20 <argint>
80105ae2:	83 c4 10             	add    $0x10,%esp
80105ae5:	85 c0                	test   %eax,%eax
80105ae7:	78 17                	js     80105b00 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80105ae9:	83 ec 08             	sub    $0x8,%esp
80105aec:	ff 75 0c             	pushl  0xc(%ebp)
80105aef:	ff 75 f4             	pushl  -0xc(%ebp)
80105af2:	e8 b9 fe ff ff       	call   801059b0 <fetchstr>
80105af7:	83 c4 10             	add    $0x10,%esp
}
80105afa:	c9                   	leave  
80105afb:	c3                   	ret    
80105afc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105b00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b05:	c9                   	leave  
80105b06:	c3                   	ret    
80105b07:	89 f6                	mov    %esi,%esi
80105b09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105b10 <syscall>:

};

void
syscall(void)
{
80105b10:	55                   	push   %ebp
80105b11:	89 e5                	mov    %esp,%ebp
80105b13:	53                   	push   %ebx
80105b14:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80105b17:	e8 84 dd ff ff       	call   801038a0 <myproc>
80105b1c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80105b1e:	8b 40 18             	mov    0x18(%eax),%eax
80105b21:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105b24:	8d 50 ff             	lea    -0x1(%eax),%edx
80105b27:	83 fa 18             	cmp    $0x18,%edx
80105b2a:	77 1c                	ja     80105b48 <syscall+0x38>
80105b2c:	8b 14 85 80 8d 10 80 	mov    -0x7fef7280(,%eax,4),%edx
80105b33:	85 d2                	test   %edx,%edx
80105b35:	74 11                	je     80105b48 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80105b37:	ff d2                	call   *%edx
80105b39:	8b 53 18             	mov    0x18(%ebx),%edx
80105b3c:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80105b3f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105b42:	c9                   	leave  
80105b43:	c3                   	ret    
80105b44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
80105b48:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80105b49:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80105b4c:	50                   	push   %eax
80105b4d:	ff 73 10             	pushl  0x10(%ebx)
80105b50:	68 55 8d 10 80       	push   $0x80108d55
80105b55:	e8 06 ab ff ff       	call   80100660 <cprintf>
    curproc->tf->eax = -1;
80105b5a:	8b 43 18             	mov    0x18(%ebx),%eax
80105b5d:	83 c4 10             	add    $0x10,%esp
80105b60:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80105b67:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105b6a:	c9                   	leave  
80105b6b:	c3                   	ret    
80105b6c:	66 90                	xchg   %ax,%ax
80105b6e:	66 90                	xchg   %ax,%ax

80105b70 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80105b70:	55                   	push   %ebp
80105b71:	89 e5                	mov    %esp,%ebp
80105b73:	57                   	push   %edi
80105b74:	56                   	push   %esi
80105b75:	53                   	push   %ebx
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105b76:	8d 75 da             	lea    -0x26(%ebp),%esi
{
80105b79:	83 ec 34             	sub    $0x34,%esp
80105b7c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80105b7f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80105b82:	56                   	push   %esi
80105b83:	50                   	push   %eax
{
80105b84:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80105b87:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80105b8a:	e8 71 c3 ff ff       	call   80101f00 <nameiparent>
80105b8f:	83 c4 10             	add    $0x10,%esp
80105b92:	85 c0                	test   %eax,%eax
80105b94:	0f 84 46 01 00 00    	je     80105ce0 <create+0x170>
    return 0;
  ilock(dp);
80105b9a:	83 ec 0c             	sub    $0xc,%esp
80105b9d:	89 c3                	mov    %eax,%ebx
80105b9f:	50                   	push   %eax
80105ba0:	e8 db ba ff ff       	call   80101680 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80105ba5:	83 c4 0c             	add    $0xc,%esp
80105ba8:	6a 00                	push   $0x0
80105baa:	56                   	push   %esi
80105bab:	53                   	push   %ebx
80105bac:	e8 ff bf ff ff       	call   80101bb0 <dirlookup>
80105bb1:	83 c4 10             	add    $0x10,%esp
80105bb4:	85 c0                	test   %eax,%eax
80105bb6:	89 c7                	mov    %eax,%edi
80105bb8:	74 36                	je     80105bf0 <create+0x80>
    iunlockput(dp);
80105bba:	83 ec 0c             	sub    $0xc,%esp
80105bbd:	53                   	push   %ebx
80105bbe:	e8 4d bd ff ff       	call   80101910 <iunlockput>
    ilock(ip);
80105bc3:	89 3c 24             	mov    %edi,(%esp)
80105bc6:	e8 b5 ba ff ff       	call   80101680 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80105bcb:	83 c4 10             	add    $0x10,%esp
80105bce:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105bd3:	0f 85 97 00 00 00    	jne    80105c70 <create+0x100>
80105bd9:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
80105bde:	0f 85 8c 00 00 00    	jne    80105c70 <create+0x100>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80105be4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105be7:	89 f8                	mov    %edi,%eax
80105be9:	5b                   	pop    %ebx
80105bea:	5e                   	pop    %esi
80105beb:	5f                   	pop    %edi
80105bec:	5d                   	pop    %ebp
80105bed:	c3                   	ret    
80105bee:	66 90                	xchg   %ax,%ax
  if((ip = ialloc(dp->dev, type)) == 0)
80105bf0:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80105bf4:	83 ec 08             	sub    $0x8,%esp
80105bf7:	50                   	push   %eax
80105bf8:	ff 33                	pushl  (%ebx)
80105bfa:	e8 11 b9 ff ff       	call   80101510 <ialloc>
80105bff:	83 c4 10             	add    $0x10,%esp
80105c02:	85 c0                	test   %eax,%eax
80105c04:	89 c7                	mov    %eax,%edi
80105c06:	0f 84 e8 00 00 00    	je     80105cf4 <create+0x184>
  ilock(ip);
80105c0c:	83 ec 0c             	sub    $0xc,%esp
80105c0f:	50                   	push   %eax
80105c10:	e8 6b ba ff ff       	call   80101680 <ilock>
  ip->major = major;
80105c15:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80105c19:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
80105c1d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80105c21:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
80105c25:	b8 01 00 00 00       	mov    $0x1,%eax
80105c2a:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
80105c2e:	89 3c 24             	mov    %edi,(%esp)
80105c31:	e8 9a b9 ff ff       	call   801015d0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80105c36:	83 c4 10             	add    $0x10,%esp
80105c39:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80105c3e:	74 50                	je     80105c90 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80105c40:	83 ec 04             	sub    $0x4,%esp
80105c43:	ff 77 04             	pushl  0x4(%edi)
80105c46:	56                   	push   %esi
80105c47:	53                   	push   %ebx
80105c48:	e8 d3 c1 ff ff       	call   80101e20 <dirlink>
80105c4d:	83 c4 10             	add    $0x10,%esp
80105c50:	85 c0                	test   %eax,%eax
80105c52:	0f 88 8f 00 00 00    	js     80105ce7 <create+0x177>
  iunlockput(dp);
80105c58:	83 ec 0c             	sub    $0xc,%esp
80105c5b:	53                   	push   %ebx
80105c5c:	e8 af bc ff ff       	call   80101910 <iunlockput>
  return ip;
80105c61:	83 c4 10             	add    $0x10,%esp
}
80105c64:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c67:	89 f8                	mov    %edi,%eax
80105c69:	5b                   	pop    %ebx
80105c6a:	5e                   	pop    %esi
80105c6b:	5f                   	pop    %edi
80105c6c:	5d                   	pop    %ebp
80105c6d:	c3                   	ret    
80105c6e:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80105c70:	83 ec 0c             	sub    $0xc,%esp
80105c73:	57                   	push   %edi
    return 0;
80105c74:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
80105c76:	e8 95 bc ff ff       	call   80101910 <iunlockput>
    return 0;
80105c7b:	83 c4 10             	add    $0x10,%esp
}
80105c7e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c81:	89 f8                	mov    %edi,%eax
80105c83:	5b                   	pop    %ebx
80105c84:	5e                   	pop    %esi
80105c85:	5f                   	pop    %edi
80105c86:	5d                   	pop    %ebp
80105c87:	c3                   	ret    
80105c88:	90                   	nop
80105c89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink++;  // for ".."
80105c90:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80105c95:	83 ec 0c             	sub    $0xc,%esp
80105c98:	53                   	push   %ebx
80105c99:	e8 32 b9 ff ff       	call   801015d0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80105c9e:	83 c4 0c             	add    $0xc,%esp
80105ca1:	ff 77 04             	pushl  0x4(%edi)
80105ca4:	68 04 8e 10 80       	push   $0x80108e04
80105ca9:	57                   	push   %edi
80105caa:	e8 71 c1 ff ff       	call   80101e20 <dirlink>
80105caf:	83 c4 10             	add    $0x10,%esp
80105cb2:	85 c0                	test   %eax,%eax
80105cb4:	78 1c                	js     80105cd2 <create+0x162>
80105cb6:	83 ec 04             	sub    $0x4,%esp
80105cb9:	ff 73 04             	pushl  0x4(%ebx)
80105cbc:	68 03 8e 10 80       	push   $0x80108e03
80105cc1:	57                   	push   %edi
80105cc2:	e8 59 c1 ff ff       	call   80101e20 <dirlink>
80105cc7:	83 c4 10             	add    $0x10,%esp
80105cca:	85 c0                	test   %eax,%eax
80105ccc:	0f 89 6e ff ff ff    	jns    80105c40 <create+0xd0>
      panic("create dots");
80105cd2:	83 ec 0c             	sub    $0xc,%esp
80105cd5:	68 f7 8d 10 80       	push   $0x80108df7
80105cda:	e8 b1 a6 ff ff       	call   80100390 <panic>
80105cdf:	90                   	nop
    return 0;
80105ce0:	31 ff                	xor    %edi,%edi
80105ce2:	e9 fd fe ff ff       	jmp    80105be4 <create+0x74>
    panic("create: dirlink");
80105ce7:	83 ec 0c             	sub    $0xc,%esp
80105cea:	68 06 8e 10 80       	push   $0x80108e06
80105cef:	e8 9c a6 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80105cf4:	83 ec 0c             	sub    $0xc,%esp
80105cf7:	68 e8 8d 10 80       	push   $0x80108de8
80105cfc:	e8 8f a6 ff ff       	call   80100390 <panic>
80105d01:	eb 0d                	jmp    80105d10 <argfd.constprop.0>
80105d03:	90                   	nop
80105d04:	90                   	nop
80105d05:	90                   	nop
80105d06:	90                   	nop
80105d07:	90                   	nop
80105d08:	90                   	nop
80105d09:	90                   	nop
80105d0a:	90                   	nop
80105d0b:	90                   	nop
80105d0c:	90                   	nop
80105d0d:	90                   	nop
80105d0e:	90                   	nop
80105d0f:	90                   	nop

80105d10 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80105d10:	55                   	push   %ebp
80105d11:	89 e5                	mov    %esp,%ebp
80105d13:	56                   	push   %esi
80105d14:	53                   	push   %ebx
80105d15:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80105d17:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
80105d1a:	89 d6                	mov    %edx,%esi
80105d1c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80105d1f:	50                   	push   %eax
80105d20:	6a 00                	push   $0x0
80105d22:	e8 f9 fc ff ff       	call   80105a20 <argint>
80105d27:	83 c4 10             	add    $0x10,%esp
80105d2a:	85 c0                	test   %eax,%eax
80105d2c:	78 2a                	js     80105d58 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80105d2e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105d32:	77 24                	ja     80105d58 <argfd.constprop.0+0x48>
80105d34:	e8 67 db ff ff       	call   801038a0 <myproc>
80105d39:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105d3c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80105d40:	85 c0                	test   %eax,%eax
80105d42:	74 14                	je     80105d58 <argfd.constprop.0+0x48>
  if(pfd)
80105d44:	85 db                	test   %ebx,%ebx
80105d46:	74 02                	je     80105d4a <argfd.constprop.0+0x3a>
    *pfd = fd;
80105d48:	89 13                	mov    %edx,(%ebx)
    *pf = f;
80105d4a:	89 06                	mov    %eax,(%esi)
  return 0;
80105d4c:	31 c0                	xor    %eax,%eax
}
80105d4e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105d51:	5b                   	pop    %ebx
80105d52:	5e                   	pop    %esi
80105d53:	5d                   	pop    %ebp
80105d54:	c3                   	ret    
80105d55:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105d58:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d5d:	eb ef                	jmp    80105d4e <argfd.constprop.0+0x3e>
80105d5f:	90                   	nop

80105d60 <sys_dup>:
{
80105d60:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80105d61:	31 c0                	xor    %eax,%eax
{
80105d63:	89 e5                	mov    %esp,%ebp
80105d65:	56                   	push   %esi
80105d66:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80105d67:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
80105d6a:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
80105d6d:	e8 9e ff ff ff       	call   80105d10 <argfd.constprop.0>
80105d72:	85 c0                	test   %eax,%eax
80105d74:	78 42                	js     80105db8 <sys_dup+0x58>
  if((fd=fdalloc(f)) < 0)
80105d76:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105d79:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105d7b:	e8 20 db ff ff       	call   801038a0 <myproc>
80105d80:	eb 0e                	jmp    80105d90 <sys_dup+0x30>
80105d82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105d88:	83 c3 01             	add    $0x1,%ebx
80105d8b:	83 fb 10             	cmp    $0x10,%ebx
80105d8e:	74 28                	je     80105db8 <sys_dup+0x58>
    if(curproc->ofile[fd] == 0){
80105d90:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105d94:	85 d2                	test   %edx,%edx
80105d96:	75 f0                	jne    80105d88 <sys_dup+0x28>
      curproc->ofile[fd] = f;
80105d98:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80105d9c:	83 ec 0c             	sub    $0xc,%esp
80105d9f:	ff 75 f4             	pushl  -0xc(%ebp)
80105da2:	e8 49 b0 ff ff       	call   80100df0 <filedup>
  return fd;
80105da7:	83 c4 10             	add    $0x10,%esp
}
80105daa:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105dad:	89 d8                	mov    %ebx,%eax
80105daf:	5b                   	pop    %ebx
80105db0:	5e                   	pop    %esi
80105db1:	5d                   	pop    %ebp
80105db2:	c3                   	ret    
80105db3:	90                   	nop
80105db4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105db8:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80105dbb:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105dc0:	89 d8                	mov    %ebx,%eax
80105dc2:	5b                   	pop    %ebx
80105dc3:	5e                   	pop    %esi
80105dc4:	5d                   	pop    %ebp
80105dc5:	c3                   	ret    
80105dc6:	8d 76 00             	lea    0x0(%esi),%esi
80105dc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105dd0 <sys_read>:
{
80105dd0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105dd1:	31 c0                	xor    %eax,%eax
{
80105dd3:	89 e5                	mov    %esp,%ebp
80105dd5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105dd8:	8d 55 ec             	lea    -0x14(%ebp),%edx
80105ddb:	e8 30 ff ff ff       	call   80105d10 <argfd.constprop.0>
80105de0:	85 c0                	test   %eax,%eax
80105de2:	78 4c                	js     80105e30 <sys_read+0x60>
80105de4:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105de7:	83 ec 08             	sub    $0x8,%esp
80105dea:	50                   	push   %eax
80105deb:	6a 02                	push   $0x2
80105ded:	e8 2e fc ff ff       	call   80105a20 <argint>
80105df2:	83 c4 10             	add    $0x10,%esp
80105df5:	85 c0                	test   %eax,%eax
80105df7:	78 37                	js     80105e30 <sys_read+0x60>
80105df9:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105dfc:	83 ec 04             	sub    $0x4,%esp
80105dff:	ff 75 f0             	pushl  -0x10(%ebp)
80105e02:	50                   	push   %eax
80105e03:	6a 01                	push   $0x1
80105e05:	e8 66 fc ff ff       	call   80105a70 <argptr>
80105e0a:	83 c4 10             	add    $0x10,%esp
80105e0d:	85 c0                	test   %eax,%eax
80105e0f:	78 1f                	js     80105e30 <sys_read+0x60>
  return fileread(f, p, n);
80105e11:	83 ec 04             	sub    $0x4,%esp
80105e14:	ff 75 f0             	pushl  -0x10(%ebp)
80105e17:	ff 75 f4             	pushl  -0xc(%ebp)
80105e1a:	ff 75 ec             	pushl  -0x14(%ebp)
80105e1d:	e8 3e b1 ff ff       	call   80100f60 <fileread>
80105e22:	83 c4 10             	add    $0x10,%esp
}
80105e25:	c9                   	leave  
80105e26:	c3                   	ret    
80105e27:	89 f6                	mov    %esi,%esi
80105e29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105e30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105e35:	c9                   	leave  
80105e36:	c3                   	ret    
80105e37:	89 f6                	mov    %esi,%esi
80105e39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105e40 <sys_write>:
{
80105e40:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105e41:	31 c0                	xor    %eax,%eax
{
80105e43:	89 e5                	mov    %esp,%ebp
80105e45:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105e48:	8d 55 ec             	lea    -0x14(%ebp),%edx
80105e4b:	e8 c0 fe ff ff       	call   80105d10 <argfd.constprop.0>
80105e50:	85 c0                	test   %eax,%eax
80105e52:	78 4c                	js     80105ea0 <sys_write+0x60>
80105e54:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105e57:	83 ec 08             	sub    $0x8,%esp
80105e5a:	50                   	push   %eax
80105e5b:	6a 02                	push   $0x2
80105e5d:	e8 be fb ff ff       	call   80105a20 <argint>
80105e62:	83 c4 10             	add    $0x10,%esp
80105e65:	85 c0                	test   %eax,%eax
80105e67:	78 37                	js     80105ea0 <sys_write+0x60>
80105e69:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105e6c:	83 ec 04             	sub    $0x4,%esp
80105e6f:	ff 75 f0             	pushl  -0x10(%ebp)
80105e72:	50                   	push   %eax
80105e73:	6a 01                	push   $0x1
80105e75:	e8 f6 fb ff ff       	call   80105a70 <argptr>
80105e7a:	83 c4 10             	add    $0x10,%esp
80105e7d:	85 c0                	test   %eax,%eax
80105e7f:	78 1f                	js     80105ea0 <sys_write+0x60>
  return filewrite(f, p, n);
80105e81:	83 ec 04             	sub    $0x4,%esp
80105e84:	ff 75 f0             	pushl  -0x10(%ebp)
80105e87:	ff 75 f4             	pushl  -0xc(%ebp)
80105e8a:	ff 75 ec             	pushl  -0x14(%ebp)
80105e8d:	e8 5e b1 ff ff       	call   80100ff0 <filewrite>
80105e92:	83 c4 10             	add    $0x10,%esp
}
80105e95:	c9                   	leave  
80105e96:	c3                   	ret    
80105e97:	89 f6                	mov    %esi,%esi
80105e99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105ea0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ea5:	c9                   	leave  
80105ea6:	c3                   	ret    
80105ea7:	89 f6                	mov    %esi,%esi
80105ea9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105eb0 <sys_close>:
{
80105eb0:	55                   	push   %ebp
80105eb1:	89 e5                	mov    %esp,%ebp
80105eb3:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
80105eb6:	8d 55 f4             	lea    -0xc(%ebp),%edx
80105eb9:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105ebc:	e8 4f fe ff ff       	call   80105d10 <argfd.constprop.0>
80105ec1:	85 c0                	test   %eax,%eax
80105ec3:	78 2b                	js     80105ef0 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80105ec5:	e8 d6 d9 ff ff       	call   801038a0 <myproc>
80105eca:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80105ecd:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80105ed0:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80105ed7:	00 
  fileclose(f);
80105ed8:	ff 75 f4             	pushl  -0xc(%ebp)
80105edb:	e8 60 af ff ff       	call   80100e40 <fileclose>
  return 0;
80105ee0:	83 c4 10             	add    $0x10,%esp
80105ee3:	31 c0                	xor    %eax,%eax
}
80105ee5:	c9                   	leave  
80105ee6:	c3                   	ret    
80105ee7:	89 f6                	mov    %esi,%esi
80105ee9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105ef0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ef5:	c9                   	leave  
80105ef6:	c3                   	ret    
80105ef7:	89 f6                	mov    %esi,%esi
80105ef9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105f00 <sys_fstat>:
{
80105f00:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105f01:	31 c0                	xor    %eax,%eax
{
80105f03:	89 e5                	mov    %esp,%ebp
80105f05:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105f08:	8d 55 f0             	lea    -0x10(%ebp),%edx
80105f0b:	e8 00 fe ff ff       	call   80105d10 <argfd.constprop.0>
80105f10:	85 c0                	test   %eax,%eax
80105f12:	78 2c                	js     80105f40 <sys_fstat+0x40>
80105f14:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105f17:	83 ec 04             	sub    $0x4,%esp
80105f1a:	6a 14                	push   $0x14
80105f1c:	50                   	push   %eax
80105f1d:	6a 01                	push   $0x1
80105f1f:	e8 4c fb ff ff       	call   80105a70 <argptr>
80105f24:	83 c4 10             	add    $0x10,%esp
80105f27:	85 c0                	test   %eax,%eax
80105f29:	78 15                	js     80105f40 <sys_fstat+0x40>
  return filestat(f, st);
80105f2b:	83 ec 08             	sub    $0x8,%esp
80105f2e:	ff 75 f4             	pushl  -0xc(%ebp)
80105f31:	ff 75 f0             	pushl  -0x10(%ebp)
80105f34:	e8 d7 af ff ff       	call   80100f10 <filestat>
80105f39:	83 c4 10             	add    $0x10,%esp
}
80105f3c:	c9                   	leave  
80105f3d:	c3                   	ret    
80105f3e:	66 90                	xchg   %ax,%ax
    return -1;
80105f40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105f45:	c9                   	leave  
80105f46:	c3                   	ret    
80105f47:	89 f6                	mov    %esi,%esi
80105f49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105f50 <sys_link>:
{
80105f50:	55                   	push   %ebp
80105f51:	89 e5                	mov    %esp,%ebp
80105f53:	57                   	push   %edi
80105f54:	56                   	push   %esi
80105f55:	53                   	push   %ebx
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105f56:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105f59:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105f5c:	50                   	push   %eax
80105f5d:	6a 00                	push   $0x0
80105f5f:	e8 6c fb ff ff       	call   80105ad0 <argstr>
80105f64:	83 c4 10             	add    $0x10,%esp
80105f67:	85 c0                	test   %eax,%eax
80105f69:	0f 88 fb 00 00 00    	js     8010606a <sys_link+0x11a>
80105f6f:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105f72:	83 ec 08             	sub    $0x8,%esp
80105f75:	50                   	push   %eax
80105f76:	6a 01                	push   $0x1
80105f78:	e8 53 fb ff ff       	call   80105ad0 <argstr>
80105f7d:	83 c4 10             	add    $0x10,%esp
80105f80:	85 c0                	test   %eax,%eax
80105f82:	0f 88 e2 00 00 00    	js     8010606a <sys_link+0x11a>
  begin_op();
80105f88:	e8 13 cc ff ff       	call   80102ba0 <begin_op>
  if((ip = namei(old)) == 0){
80105f8d:	83 ec 0c             	sub    $0xc,%esp
80105f90:	ff 75 d4             	pushl  -0x2c(%ebp)
80105f93:	e8 48 bf ff ff       	call   80101ee0 <namei>
80105f98:	83 c4 10             	add    $0x10,%esp
80105f9b:	85 c0                	test   %eax,%eax
80105f9d:	89 c3                	mov    %eax,%ebx
80105f9f:	0f 84 ea 00 00 00    	je     8010608f <sys_link+0x13f>
  ilock(ip);
80105fa5:	83 ec 0c             	sub    $0xc,%esp
80105fa8:	50                   	push   %eax
80105fa9:	e8 d2 b6 ff ff       	call   80101680 <ilock>
  if(ip->type == T_DIR){
80105fae:	83 c4 10             	add    $0x10,%esp
80105fb1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105fb6:	0f 84 bb 00 00 00    	je     80106077 <sys_link+0x127>
  ip->nlink++;
80105fbc:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80105fc1:	83 ec 0c             	sub    $0xc,%esp
  if((dp = nameiparent(new, name)) == 0)
80105fc4:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105fc7:	53                   	push   %ebx
80105fc8:	e8 03 b6 ff ff       	call   801015d0 <iupdate>
  iunlock(ip);
80105fcd:	89 1c 24             	mov    %ebx,(%esp)
80105fd0:	e8 8b b7 ff ff       	call   80101760 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105fd5:	58                   	pop    %eax
80105fd6:	5a                   	pop    %edx
80105fd7:	57                   	push   %edi
80105fd8:	ff 75 d0             	pushl  -0x30(%ebp)
80105fdb:	e8 20 bf ff ff       	call   80101f00 <nameiparent>
80105fe0:	83 c4 10             	add    $0x10,%esp
80105fe3:	85 c0                	test   %eax,%eax
80105fe5:	89 c6                	mov    %eax,%esi
80105fe7:	74 5b                	je     80106044 <sys_link+0xf4>
  ilock(dp);
80105fe9:	83 ec 0c             	sub    $0xc,%esp
80105fec:	50                   	push   %eax
80105fed:	e8 8e b6 ff ff       	call   80101680 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105ff2:	83 c4 10             	add    $0x10,%esp
80105ff5:	8b 03                	mov    (%ebx),%eax
80105ff7:	39 06                	cmp    %eax,(%esi)
80105ff9:	75 3d                	jne    80106038 <sys_link+0xe8>
80105ffb:	83 ec 04             	sub    $0x4,%esp
80105ffe:	ff 73 04             	pushl  0x4(%ebx)
80106001:	57                   	push   %edi
80106002:	56                   	push   %esi
80106003:	e8 18 be ff ff       	call   80101e20 <dirlink>
80106008:	83 c4 10             	add    $0x10,%esp
8010600b:	85 c0                	test   %eax,%eax
8010600d:	78 29                	js     80106038 <sys_link+0xe8>
  iunlockput(dp);
8010600f:	83 ec 0c             	sub    $0xc,%esp
80106012:	56                   	push   %esi
80106013:	e8 f8 b8 ff ff       	call   80101910 <iunlockput>
  iput(ip);
80106018:	89 1c 24             	mov    %ebx,(%esp)
8010601b:	e8 90 b7 ff ff       	call   801017b0 <iput>
  end_op();
80106020:	e8 eb cb ff ff       	call   80102c10 <end_op>
  return 0;
80106025:	83 c4 10             	add    $0x10,%esp
80106028:	31 c0                	xor    %eax,%eax
}
8010602a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010602d:	5b                   	pop    %ebx
8010602e:	5e                   	pop    %esi
8010602f:	5f                   	pop    %edi
80106030:	5d                   	pop    %ebp
80106031:	c3                   	ret    
80106032:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80106038:	83 ec 0c             	sub    $0xc,%esp
8010603b:	56                   	push   %esi
8010603c:	e8 cf b8 ff ff       	call   80101910 <iunlockput>
    goto bad;
80106041:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80106044:	83 ec 0c             	sub    $0xc,%esp
80106047:	53                   	push   %ebx
80106048:	e8 33 b6 ff ff       	call   80101680 <ilock>
  ip->nlink--;
8010604d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80106052:	89 1c 24             	mov    %ebx,(%esp)
80106055:	e8 76 b5 ff ff       	call   801015d0 <iupdate>
  iunlockput(ip);
8010605a:	89 1c 24             	mov    %ebx,(%esp)
8010605d:	e8 ae b8 ff ff       	call   80101910 <iunlockput>
  end_op();
80106062:	e8 a9 cb ff ff       	call   80102c10 <end_op>
  return -1;
80106067:	83 c4 10             	add    $0x10,%esp
}
8010606a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010606d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106072:	5b                   	pop    %ebx
80106073:	5e                   	pop    %esi
80106074:	5f                   	pop    %edi
80106075:	5d                   	pop    %ebp
80106076:	c3                   	ret    
    iunlockput(ip);
80106077:	83 ec 0c             	sub    $0xc,%esp
8010607a:	53                   	push   %ebx
8010607b:	e8 90 b8 ff ff       	call   80101910 <iunlockput>
    end_op();
80106080:	e8 8b cb ff ff       	call   80102c10 <end_op>
    return -1;
80106085:	83 c4 10             	add    $0x10,%esp
80106088:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010608d:	eb 9b                	jmp    8010602a <sys_link+0xda>
    end_op();
8010608f:	e8 7c cb ff ff       	call   80102c10 <end_op>
    return -1;
80106094:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106099:	eb 8f                	jmp    8010602a <sys_link+0xda>
8010609b:	90                   	nop
8010609c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801060a0 <sys_unlink>:
{
801060a0:	55                   	push   %ebp
801060a1:	89 e5                	mov    %esp,%ebp
801060a3:	57                   	push   %edi
801060a4:	56                   	push   %esi
801060a5:	53                   	push   %ebx
  if(argstr(0, &path) < 0)
801060a6:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
801060a9:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
801060ac:	50                   	push   %eax
801060ad:	6a 00                	push   $0x0
801060af:	e8 1c fa ff ff       	call   80105ad0 <argstr>
801060b4:	83 c4 10             	add    $0x10,%esp
801060b7:	85 c0                	test   %eax,%eax
801060b9:	0f 88 77 01 00 00    	js     80106236 <sys_unlink+0x196>
  if((dp = nameiparent(path, name)) == 0){
801060bf:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  begin_op();
801060c2:	e8 d9 ca ff ff       	call   80102ba0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801060c7:	83 ec 08             	sub    $0x8,%esp
801060ca:	53                   	push   %ebx
801060cb:	ff 75 c0             	pushl  -0x40(%ebp)
801060ce:	e8 2d be ff ff       	call   80101f00 <nameiparent>
801060d3:	83 c4 10             	add    $0x10,%esp
801060d6:	85 c0                	test   %eax,%eax
801060d8:	89 c6                	mov    %eax,%esi
801060da:	0f 84 60 01 00 00    	je     80106240 <sys_unlink+0x1a0>
  ilock(dp);
801060e0:	83 ec 0c             	sub    $0xc,%esp
801060e3:	50                   	push   %eax
801060e4:	e8 97 b5 ff ff       	call   80101680 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801060e9:	58                   	pop    %eax
801060ea:	5a                   	pop    %edx
801060eb:	68 04 8e 10 80       	push   $0x80108e04
801060f0:	53                   	push   %ebx
801060f1:	e8 9a ba ff ff       	call   80101b90 <namecmp>
801060f6:	83 c4 10             	add    $0x10,%esp
801060f9:	85 c0                	test   %eax,%eax
801060fb:	0f 84 03 01 00 00    	je     80106204 <sys_unlink+0x164>
80106101:	83 ec 08             	sub    $0x8,%esp
80106104:	68 03 8e 10 80       	push   $0x80108e03
80106109:	53                   	push   %ebx
8010610a:	e8 81 ba ff ff       	call   80101b90 <namecmp>
8010610f:	83 c4 10             	add    $0x10,%esp
80106112:	85 c0                	test   %eax,%eax
80106114:	0f 84 ea 00 00 00    	je     80106204 <sys_unlink+0x164>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010611a:	8d 45 c4             	lea    -0x3c(%ebp),%eax
8010611d:	83 ec 04             	sub    $0x4,%esp
80106120:	50                   	push   %eax
80106121:	53                   	push   %ebx
80106122:	56                   	push   %esi
80106123:	e8 88 ba ff ff       	call   80101bb0 <dirlookup>
80106128:	83 c4 10             	add    $0x10,%esp
8010612b:	85 c0                	test   %eax,%eax
8010612d:	89 c3                	mov    %eax,%ebx
8010612f:	0f 84 cf 00 00 00    	je     80106204 <sys_unlink+0x164>
  ilock(ip);
80106135:	83 ec 0c             	sub    $0xc,%esp
80106138:	50                   	push   %eax
80106139:	e8 42 b5 ff ff       	call   80101680 <ilock>
  if(ip->nlink < 1)
8010613e:	83 c4 10             	add    $0x10,%esp
80106141:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80106146:	0f 8e 10 01 00 00    	jle    8010625c <sys_unlink+0x1bc>
  if(ip->type == T_DIR && !isdirempty(ip)){
8010614c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80106151:	74 6d                	je     801061c0 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
80106153:	8d 45 d8             	lea    -0x28(%ebp),%eax
80106156:	83 ec 04             	sub    $0x4,%esp
80106159:	6a 10                	push   $0x10
8010615b:	6a 00                	push   $0x0
8010615d:	50                   	push   %eax
8010615e:	e8 bd f5 ff ff       	call   80105720 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80106163:	8d 45 d8             	lea    -0x28(%ebp),%eax
80106166:	6a 10                	push   $0x10
80106168:	ff 75 c4             	pushl  -0x3c(%ebp)
8010616b:	50                   	push   %eax
8010616c:	56                   	push   %esi
8010616d:	e8 ee b8 ff ff       	call   80101a60 <writei>
80106172:	83 c4 20             	add    $0x20,%esp
80106175:	83 f8 10             	cmp    $0x10,%eax
80106178:	0f 85 eb 00 00 00    	jne    80106269 <sys_unlink+0x1c9>
  if(ip->type == T_DIR){
8010617e:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80106183:	0f 84 97 00 00 00    	je     80106220 <sys_unlink+0x180>
  iunlockput(dp);
80106189:	83 ec 0c             	sub    $0xc,%esp
8010618c:	56                   	push   %esi
8010618d:	e8 7e b7 ff ff       	call   80101910 <iunlockput>
  ip->nlink--;
80106192:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80106197:	89 1c 24             	mov    %ebx,(%esp)
8010619a:	e8 31 b4 ff ff       	call   801015d0 <iupdate>
  iunlockput(ip);
8010619f:	89 1c 24             	mov    %ebx,(%esp)
801061a2:	e8 69 b7 ff ff       	call   80101910 <iunlockput>
  end_op();
801061a7:	e8 64 ca ff ff       	call   80102c10 <end_op>
  return 0;
801061ac:	83 c4 10             	add    $0x10,%esp
801061af:	31 c0                	xor    %eax,%eax
}
801061b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801061b4:	5b                   	pop    %ebx
801061b5:	5e                   	pop    %esi
801061b6:	5f                   	pop    %edi
801061b7:	5d                   	pop    %ebp
801061b8:	c3                   	ret    
801061b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801061c0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
801061c4:	76 8d                	jbe    80106153 <sys_unlink+0xb3>
801061c6:	bf 20 00 00 00       	mov    $0x20,%edi
801061cb:	eb 0f                	jmp    801061dc <sys_unlink+0x13c>
801061cd:	8d 76 00             	lea    0x0(%esi),%esi
801061d0:	83 c7 10             	add    $0x10,%edi
801061d3:	3b 7b 58             	cmp    0x58(%ebx),%edi
801061d6:	0f 83 77 ff ff ff    	jae    80106153 <sys_unlink+0xb3>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801061dc:	8d 45 d8             	lea    -0x28(%ebp),%eax
801061df:	6a 10                	push   $0x10
801061e1:	57                   	push   %edi
801061e2:	50                   	push   %eax
801061e3:	53                   	push   %ebx
801061e4:	e8 77 b7 ff ff       	call   80101960 <readi>
801061e9:	83 c4 10             	add    $0x10,%esp
801061ec:	83 f8 10             	cmp    $0x10,%eax
801061ef:	75 5e                	jne    8010624f <sys_unlink+0x1af>
    if(de.inum != 0)
801061f1:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801061f6:	74 d8                	je     801061d0 <sys_unlink+0x130>
    iunlockput(ip);
801061f8:	83 ec 0c             	sub    $0xc,%esp
801061fb:	53                   	push   %ebx
801061fc:	e8 0f b7 ff ff       	call   80101910 <iunlockput>
    goto bad;
80106201:	83 c4 10             	add    $0x10,%esp
  iunlockput(dp);
80106204:	83 ec 0c             	sub    $0xc,%esp
80106207:	56                   	push   %esi
80106208:	e8 03 b7 ff ff       	call   80101910 <iunlockput>
  end_op();
8010620d:	e8 fe c9 ff ff       	call   80102c10 <end_op>
  return -1;
80106212:	83 c4 10             	add    $0x10,%esp
80106215:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010621a:	eb 95                	jmp    801061b1 <sys_unlink+0x111>
8010621c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink--;
80106220:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80106225:	83 ec 0c             	sub    $0xc,%esp
80106228:	56                   	push   %esi
80106229:	e8 a2 b3 ff ff       	call   801015d0 <iupdate>
8010622e:	83 c4 10             	add    $0x10,%esp
80106231:	e9 53 ff ff ff       	jmp    80106189 <sys_unlink+0xe9>
    return -1;
80106236:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010623b:	e9 71 ff ff ff       	jmp    801061b1 <sys_unlink+0x111>
    end_op();
80106240:	e8 cb c9 ff ff       	call   80102c10 <end_op>
    return -1;
80106245:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010624a:	e9 62 ff ff ff       	jmp    801061b1 <sys_unlink+0x111>
      panic("isdirempty: readi");
8010624f:	83 ec 0c             	sub    $0xc,%esp
80106252:	68 28 8e 10 80       	push   $0x80108e28
80106257:	e8 34 a1 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
8010625c:	83 ec 0c             	sub    $0xc,%esp
8010625f:	68 16 8e 10 80       	push   $0x80108e16
80106264:	e8 27 a1 ff ff       	call   80100390 <panic>
    panic("unlink: writei");
80106269:	83 ec 0c             	sub    $0xc,%esp
8010626c:	68 3a 8e 10 80       	push   $0x80108e3a
80106271:	e8 1a a1 ff ff       	call   80100390 <panic>
80106276:	8d 76 00             	lea    0x0(%esi),%esi
80106279:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106280 <sys_open>:

int
sys_open(void)
{
80106280:	55                   	push   %ebp
80106281:	89 e5                	mov    %esp,%ebp
80106283:	57                   	push   %edi
80106284:	56                   	push   %esi
80106285:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80106286:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80106289:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010628c:	50                   	push   %eax
8010628d:	6a 00                	push   $0x0
8010628f:	e8 3c f8 ff ff       	call   80105ad0 <argstr>
80106294:	83 c4 10             	add    $0x10,%esp
80106297:	85 c0                	test   %eax,%eax
80106299:	0f 88 1d 01 00 00    	js     801063bc <sys_open+0x13c>
8010629f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801062a2:	83 ec 08             	sub    $0x8,%esp
801062a5:	50                   	push   %eax
801062a6:	6a 01                	push   $0x1
801062a8:	e8 73 f7 ff ff       	call   80105a20 <argint>
801062ad:	83 c4 10             	add    $0x10,%esp
801062b0:	85 c0                	test   %eax,%eax
801062b2:	0f 88 04 01 00 00    	js     801063bc <sys_open+0x13c>
    return -1;

  begin_op();
801062b8:	e8 e3 c8 ff ff       	call   80102ba0 <begin_op>

  if(omode & O_CREATE){
801062bd:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
801062c1:	0f 85 a9 00 00 00    	jne    80106370 <sys_open+0xf0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
801062c7:	83 ec 0c             	sub    $0xc,%esp
801062ca:	ff 75 e0             	pushl  -0x20(%ebp)
801062cd:	e8 0e bc ff ff       	call   80101ee0 <namei>
801062d2:	83 c4 10             	add    $0x10,%esp
801062d5:	85 c0                	test   %eax,%eax
801062d7:	89 c6                	mov    %eax,%esi
801062d9:	0f 84 b2 00 00 00    	je     80106391 <sys_open+0x111>
      end_op();
      return -1;
    }
    ilock(ip);
801062df:	83 ec 0c             	sub    $0xc,%esp
801062e2:	50                   	push   %eax
801062e3:	e8 98 b3 ff ff       	call   80101680 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801062e8:	83 c4 10             	add    $0x10,%esp
801062eb:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801062f0:	0f 84 aa 00 00 00    	je     801063a0 <sys_open+0x120>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801062f6:	e8 85 aa ff ff       	call   80100d80 <filealloc>
801062fb:	85 c0                	test   %eax,%eax
801062fd:	89 c7                	mov    %eax,%edi
801062ff:	0f 84 a6 00 00 00    	je     801063ab <sys_open+0x12b>
  struct proc *curproc = myproc();
80106305:	e8 96 d5 ff ff       	call   801038a0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010630a:	31 db                	xor    %ebx,%ebx
8010630c:	eb 0e                	jmp    8010631c <sys_open+0x9c>
8010630e:	66 90                	xchg   %ax,%ax
80106310:	83 c3 01             	add    $0x1,%ebx
80106313:	83 fb 10             	cmp    $0x10,%ebx
80106316:	0f 84 ac 00 00 00    	je     801063c8 <sys_open+0x148>
    if(curproc->ofile[fd] == 0){
8010631c:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80106320:	85 d2                	test   %edx,%edx
80106322:	75 ec                	jne    80106310 <sys_open+0x90>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80106324:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80106327:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
8010632b:	56                   	push   %esi
8010632c:	e8 2f b4 ff ff       	call   80101760 <iunlock>
  end_op();
80106331:	e8 da c8 ff ff       	call   80102c10 <end_op>

  f->type = FD_INODE;
80106336:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
8010633c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010633f:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80106342:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80106345:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
8010634c:	89 d0                	mov    %edx,%eax
8010634e:	f7 d0                	not    %eax
80106350:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80106353:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80106356:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80106359:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
8010635d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106360:	89 d8                	mov    %ebx,%eax
80106362:	5b                   	pop    %ebx
80106363:	5e                   	pop    %esi
80106364:	5f                   	pop    %edi
80106365:	5d                   	pop    %ebp
80106366:	c3                   	ret    
80106367:	89 f6                	mov    %esi,%esi
80106369:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ip = create(path, T_FILE, 0, 0);
80106370:	83 ec 0c             	sub    $0xc,%esp
80106373:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106376:	31 c9                	xor    %ecx,%ecx
80106378:	6a 00                	push   $0x0
8010637a:	ba 02 00 00 00       	mov    $0x2,%edx
8010637f:	e8 ec f7 ff ff       	call   80105b70 <create>
    if(ip == 0){
80106384:	83 c4 10             	add    $0x10,%esp
80106387:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
80106389:	89 c6                	mov    %eax,%esi
    if(ip == 0){
8010638b:	0f 85 65 ff ff ff    	jne    801062f6 <sys_open+0x76>
      end_op();
80106391:	e8 7a c8 ff ff       	call   80102c10 <end_op>
      return -1;
80106396:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010639b:	eb c0                	jmp    8010635d <sys_open+0xdd>
8010639d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
801063a0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801063a3:	85 c9                	test   %ecx,%ecx
801063a5:	0f 84 4b ff ff ff    	je     801062f6 <sys_open+0x76>
    iunlockput(ip);
801063ab:	83 ec 0c             	sub    $0xc,%esp
801063ae:	56                   	push   %esi
801063af:	e8 5c b5 ff ff       	call   80101910 <iunlockput>
    end_op();
801063b4:	e8 57 c8 ff ff       	call   80102c10 <end_op>
    return -1;
801063b9:	83 c4 10             	add    $0x10,%esp
801063bc:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801063c1:	eb 9a                	jmp    8010635d <sys_open+0xdd>
801063c3:	90                   	nop
801063c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
801063c8:	83 ec 0c             	sub    $0xc,%esp
801063cb:	57                   	push   %edi
801063cc:	e8 6f aa ff ff       	call   80100e40 <fileclose>
801063d1:	83 c4 10             	add    $0x10,%esp
801063d4:	eb d5                	jmp    801063ab <sys_open+0x12b>
801063d6:	8d 76 00             	lea    0x0(%esi),%esi
801063d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801063e0 <sys_mkdir>:

int
sys_mkdir(void)
{
801063e0:	55                   	push   %ebp
801063e1:	89 e5                	mov    %esp,%ebp
801063e3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801063e6:	e8 b5 c7 ff ff       	call   80102ba0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801063eb:	8d 45 f4             	lea    -0xc(%ebp),%eax
801063ee:	83 ec 08             	sub    $0x8,%esp
801063f1:	50                   	push   %eax
801063f2:	6a 00                	push   $0x0
801063f4:	e8 d7 f6 ff ff       	call   80105ad0 <argstr>
801063f9:	83 c4 10             	add    $0x10,%esp
801063fc:	85 c0                	test   %eax,%eax
801063fe:	78 30                	js     80106430 <sys_mkdir+0x50>
80106400:	83 ec 0c             	sub    $0xc,%esp
80106403:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106406:	31 c9                	xor    %ecx,%ecx
80106408:	6a 00                	push   $0x0
8010640a:	ba 01 00 00 00       	mov    $0x1,%edx
8010640f:	e8 5c f7 ff ff       	call   80105b70 <create>
80106414:	83 c4 10             	add    $0x10,%esp
80106417:	85 c0                	test   %eax,%eax
80106419:	74 15                	je     80106430 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010641b:	83 ec 0c             	sub    $0xc,%esp
8010641e:	50                   	push   %eax
8010641f:	e8 ec b4 ff ff       	call   80101910 <iunlockput>
  end_op();
80106424:	e8 e7 c7 ff ff       	call   80102c10 <end_op>
  return 0;
80106429:	83 c4 10             	add    $0x10,%esp
8010642c:	31 c0                	xor    %eax,%eax
}
8010642e:	c9                   	leave  
8010642f:	c3                   	ret    
    end_op();
80106430:	e8 db c7 ff ff       	call   80102c10 <end_op>
    return -1;
80106435:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010643a:	c9                   	leave  
8010643b:	c3                   	ret    
8010643c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106440 <sys_mknod>:

int
sys_mknod(void)
{
80106440:	55                   	push   %ebp
80106441:	89 e5                	mov    %esp,%ebp
80106443:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80106446:	e8 55 c7 ff ff       	call   80102ba0 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010644b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010644e:	83 ec 08             	sub    $0x8,%esp
80106451:	50                   	push   %eax
80106452:	6a 00                	push   $0x0
80106454:	e8 77 f6 ff ff       	call   80105ad0 <argstr>
80106459:	83 c4 10             	add    $0x10,%esp
8010645c:	85 c0                	test   %eax,%eax
8010645e:	78 60                	js     801064c0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80106460:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106463:	83 ec 08             	sub    $0x8,%esp
80106466:	50                   	push   %eax
80106467:	6a 01                	push   $0x1
80106469:	e8 b2 f5 ff ff       	call   80105a20 <argint>
  if((argstr(0, &path)) < 0 ||
8010646e:	83 c4 10             	add    $0x10,%esp
80106471:	85 c0                	test   %eax,%eax
80106473:	78 4b                	js     801064c0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80106475:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106478:	83 ec 08             	sub    $0x8,%esp
8010647b:	50                   	push   %eax
8010647c:	6a 02                	push   $0x2
8010647e:	e8 9d f5 ff ff       	call   80105a20 <argint>
     argint(1, &major) < 0 ||
80106483:	83 c4 10             	add    $0x10,%esp
80106486:	85 c0                	test   %eax,%eax
80106488:	78 36                	js     801064c0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010648a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
8010648e:	83 ec 0c             	sub    $0xc,%esp
     (ip = create(path, T_DEV, major, minor)) == 0){
80106491:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
     argint(2, &minor) < 0 ||
80106495:	ba 03 00 00 00       	mov    $0x3,%edx
8010649a:	50                   	push   %eax
8010649b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010649e:	e8 cd f6 ff ff       	call   80105b70 <create>
801064a3:	83 c4 10             	add    $0x10,%esp
801064a6:	85 c0                	test   %eax,%eax
801064a8:	74 16                	je     801064c0 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
801064aa:	83 ec 0c             	sub    $0xc,%esp
801064ad:	50                   	push   %eax
801064ae:	e8 5d b4 ff ff       	call   80101910 <iunlockput>
  end_op();
801064b3:	e8 58 c7 ff ff       	call   80102c10 <end_op>
  return 0;
801064b8:	83 c4 10             	add    $0x10,%esp
801064bb:	31 c0                	xor    %eax,%eax
}
801064bd:	c9                   	leave  
801064be:	c3                   	ret    
801064bf:	90                   	nop
    end_op();
801064c0:	e8 4b c7 ff ff       	call   80102c10 <end_op>
    return -1;
801064c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801064ca:	c9                   	leave  
801064cb:	c3                   	ret    
801064cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801064d0 <sys_chdir>:

int
sys_chdir(void)
{
801064d0:	55                   	push   %ebp
801064d1:	89 e5                	mov    %esp,%ebp
801064d3:	56                   	push   %esi
801064d4:	53                   	push   %ebx
801064d5:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
801064d8:	e8 c3 d3 ff ff       	call   801038a0 <myproc>
801064dd:	89 c6                	mov    %eax,%esi
  
  begin_op();
801064df:	e8 bc c6 ff ff       	call   80102ba0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801064e4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801064e7:	83 ec 08             	sub    $0x8,%esp
801064ea:	50                   	push   %eax
801064eb:	6a 00                	push   $0x0
801064ed:	e8 de f5 ff ff       	call   80105ad0 <argstr>
801064f2:	83 c4 10             	add    $0x10,%esp
801064f5:	85 c0                	test   %eax,%eax
801064f7:	78 77                	js     80106570 <sys_chdir+0xa0>
801064f9:	83 ec 0c             	sub    $0xc,%esp
801064fc:	ff 75 f4             	pushl  -0xc(%ebp)
801064ff:	e8 dc b9 ff ff       	call   80101ee0 <namei>
80106504:	83 c4 10             	add    $0x10,%esp
80106507:	85 c0                	test   %eax,%eax
80106509:	89 c3                	mov    %eax,%ebx
8010650b:	74 63                	je     80106570 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010650d:	83 ec 0c             	sub    $0xc,%esp
80106510:	50                   	push   %eax
80106511:	e8 6a b1 ff ff       	call   80101680 <ilock>
  if(ip->type != T_DIR){
80106516:	83 c4 10             	add    $0x10,%esp
80106519:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010651e:	75 30                	jne    80106550 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80106520:	83 ec 0c             	sub    $0xc,%esp
80106523:	53                   	push   %ebx
80106524:	e8 37 b2 ff ff       	call   80101760 <iunlock>
  iput(curproc->cwd);
80106529:	58                   	pop    %eax
8010652a:	ff 76 68             	pushl  0x68(%esi)
8010652d:	e8 7e b2 ff ff       	call   801017b0 <iput>
  end_op();
80106532:	e8 d9 c6 ff ff       	call   80102c10 <end_op>
  curproc->cwd = ip;
80106537:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010653a:	83 c4 10             	add    $0x10,%esp
8010653d:	31 c0                	xor    %eax,%eax
}
8010653f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106542:	5b                   	pop    %ebx
80106543:	5e                   	pop    %esi
80106544:	5d                   	pop    %ebp
80106545:	c3                   	ret    
80106546:	8d 76 00             	lea    0x0(%esi),%esi
80106549:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    iunlockput(ip);
80106550:	83 ec 0c             	sub    $0xc,%esp
80106553:	53                   	push   %ebx
80106554:	e8 b7 b3 ff ff       	call   80101910 <iunlockput>
    end_op();
80106559:	e8 b2 c6 ff ff       	call   80102c10 <end_op>
    return -1;
8010655e:	83 c4 10             	add    $0x10,%esp
80106561:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106566:	eb d7                	jmp    8010653f <sys_chdir+0x6f>
80106568:	90                   	nop
80106569:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80106570:	e8 9b c6 ff ff       	call   80102c10 <end_op>
    return -1;
80106575:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010657a:	eb c3                	jmp    8010653f <sys_chdir+0x6f>
8010657c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106580 <sys_exec>:

int
sys_exec(void)
{
80106580:	55                   	push   %ebp
80106581:	89 e5                	mov    %esp,%ebp
80106583:	57                   	push   %edi
80106584:	56                   	push   %esi
80106585:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80106586:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010658c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80106592:	50                   	push   %eax
80106593:	6a 00                	push   $0x0
80106595:	e8 36 f5 ff ff       	call   80105ad0 <argstr>
8010659a:	83 c4 10             	add    $0x10,%esp
8010659d:	85 c0                	test   %eax,%eax
8010659f:	0f 88 87 00 00 00    	js     8010662c <sys_exec+0xac>
801065a5:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801065ab:	83 ec 08             	sub    $0x8,%esp
801065ae:	50                   	push   %eax
801065af:	6a 01                	push   $0x1
801065b1:	e8 6a f4 ff ff       	call   80105a20 <argint>
801065b6:	83 c4 10             	add    $0x10,%esp
801065b9:	85 c0                	test   %eax,%eax
801065bb:	78 6f                	js     8010662c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801065bd:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801065c3:	83 ec 04             	sub    $0x4,%esp
  for(i=0;; i++){
801065c6:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
801065c8:	68 80 00 00 00       	push   $0x80
801065cd:	6a 00                	push   $0x0
801065cf:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
801065d5:	50                   	push   %eax
801065d6:	e8 45 f1 ff ff       	call   80105720 <memset>
801065db:	83 c4 10             	add    $0x10,%esp
801065de:	eb 2c                	jmp    8010660c <sys_exec+0x8c>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
801065e0:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801065e6:	85 c0                	test   %eax,%eax
801065e8:	74 56                	je     80106640 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801065ea:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
801065f0:	83 ec 08             	sub    $0x8,%esp
801065f3:	8d 14 31             	lea    (%ecx,%esi,1),%edx
801065f6:	52                   	push   %edx
801065f7:	50                   	push   %eax
801065f8:	e8 b3 f3 ff ff       	call   801059b0 <fetchstr>
801065fd:	83 c4 10             	add    $0x10,%esp
80106600:	85 c0                	test   %eax,%eax
80106602:	78 28                	js     8010662c <sys_exec+0xac>
  for(i=0;; i++){
80106604:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80106607:	83 fb 20             	cmp    $0x20,%ebx
8010660a:	74 20                	je     8010662c <sys_exec+0xac>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
8010660c:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80106612:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80106619:	83 ec 08             	sub    $0x8,%esp
8010661c:	57                   	push   %edi
8010661d:	01 f0                	add    %esi,%eax
8010661f:	50                   	push   %eax
80106620:	e8 4b f3 ff ff       	call   80105970 <fetchint>
80106625:	83 c4 10             	add    $0x10,%esp
80106628:	85 c0                	test   %eax,%eax
8010662a:	79 b4                	jns    801065e0 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
8010662c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010662f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106634:	5b                   	pop    %ebx
80106635:	5e                   	pop    %esi
80106636:	5f                   	pop    %edi
80106637:	5d                   	pop    %ebp
80106638:	c3                   	ret    
80106639:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80106640:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80106646:	83 ec 08             	sub    $0x8,%esp
      argv[i] = 0;
80106649:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80106650:	00 00 00 00 
  return exec(path, argv);
80106654:	50                   	push   %eax
80106655:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
8010665b:	e8 b0 a3 ff ff       	call   80100a10 <exec>
80106660:	83 c4 10             	add    $0x10,%esp
}
80106663:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106666:	5b                   	pop    %ebx
80106667:	5e                   	pop    %esi
80106668:	5f                   	pop    %edi
80106669:	5d                   	pop    %ebp
8010666a:	c3                   	ret    
8010666b:	90                   	nop
8010666c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106670 <sys_pipe>:

int
sys_pipe(void)
{
80106670:	55                   	push   %ebp
80106671:	89 e5                	mov    %esp,%ebp
80106673:	57                   	push   %edi
80106674:	56                   	push   %esi
80106675:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80106676:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80106679:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010667c:	6a 08                	push   $0x8
8010667e:	50                   	push   %eax
8010667f:	6a 00                	push   $0x0
80106681:	e8 ea f3 ff ff       	call   80105a70 <argptr>
80106686:	83 c4 10             	add    $0x10,%esp
80106689:	85 c0                	test   %eax,%eax
8010668b:	0f 88 ae 00 00 00    	js     8010673f <sys_pipe+0xcf>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80106691:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106694:	83 ec 08             	sub    $0x8,%esp
80106697:	50                   	push   %eax
80106698:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010669b:	50                   	push   %eax
8010669c:	e8 9f cb ff ff       	call   80103240 <pipealloc>
801066a1:	83 c4 10             	add    $0x10,%esp
801066a4:	85 c0                	test   %eax,%eax
801066a6:	0f 88 93 00 00 00    	js     8010673f <sys_pipe+0xcf>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801066ac:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
801066af:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801066b1:	e8 ea d1 ff ff       	call   801038a0 <myproc>
801066b6:	eb 10                	jmp    801066c8 <sys_pipe+0x58>
801066b8:	90                   	nop
801066b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(fd = 0; fd < NOFILE; fd++){
801066c0:	83 c3 01             	add    $0x1,%ebx
801066c3:	83 fb 10             	cmp    $0x10,%ebx
801066c6:	74 60                	je     80106728 <sys_pipe+0xb8>
    if(curproc->ofile[fd] == 0){
801066c8:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
801066cc:	85 f6                	test   %esi,%esi
801066ce:	75 f0                	jne    801066c0 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
801066d0:	8d 73 08             	lea    0x8(%ebx),%esi
801066d3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801066d7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
801066da:	e8 c1 d1 ff ff       	call   801038a0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801066df:	31 d2                	xor    %edx,%edx
801066e1:	eb 0d                	jmp    801066f0 <sys_pipe+0x80>
801066e3:	90                   	nop
801066e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801066e8:	83 c2 01             	add    $0x1,%edx
801066eb:	83 fa 10             	cmp    $0x10,%edx
801066ee:	74 28                	je     80106718 <sys_pipe+0xa8>
    if(curproc->ofile[fd] == 0){
801066f0:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
801066f4:	85 c9                	test   %ecx,%ecx
801066f6:	75 f0                	jne    801066e8 <sys_pipe+0x78>
      curproc->ofile[fd] = f;
801066f8:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
801066fc:	8b 45 dc             	mov    -0x24(%ebp),%eax
801066ff:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80106701:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106704:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80106707:	31 c0                	xor    %eax,%eax
}
80106709:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010670c:	5b                   	pop    %ebx
8010670d:	5e                   	pop    %esi
8010670e:	5f                   	pop    %edi
8010670f:	5d                   	pop    %ebp
80106710:	c3                   	ret    
80106711:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
80106718:	e8 83 d1 ff ff       	call   801038a0 <myproc>
8010671d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80106724:	00 
80106725:	8d 76 00             	lea    0x0(%esi),%esi
    fileclose(rf);
80106728:	83 ec 0c             	sub    $0xc,%esp
8010672b:	ff 75 e0             	pushl  -0x20(%ebp)
8010672e:	e8 0d a7 ff ff       	call   80100e40 <fileclose>
    fileclose(wf);
80106733:	58                   	pop    %eax
80106734:	ff 75 e4             	pushl  -0x1c(%ebp)
80106737:	e8 04 a7 ff ff       	call   80100e40 <fileclose>
    return -1;
8010673c:	83 c4 10             	add    $0x10,%esp
8010673f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106744:	eb c3                	jmp    80106709 <sys_pipe+0x99>
80106746:	66 90                	xchg   %ax,%ax
80106748:	66 90                	xchg   %ax,%ax
8010674a:	66 90                	xchg   %ax,%ax
8010674c:	66 90                	xchg   %ax,%ax
8010674e:	66 90                	xchg   %ax,%ax

80106750 <sys_fork>:
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"

int sys_fork(void)
{
80106750:	55                   	push   %ebp
80106751:	89 e5                	mov    %esp,%ebp
  return fork();
}
80106753:	5d                   	pop    %ebp
  return fork();
80106754:	e9 a7 d7 ff ff       	jmp    80103f00 <fork>
80106759:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106760 <sys_exit>:

int sys_exit(void)
{
80106760:	55                   	push   %ebp
80106761:	89 e5                	mov    %esp,%ebp
80106763:	83 ec 08             	sub    $0x8,%esp
  exit();
80106766:	e8 95 e3 ff ff       	call   80104b00 <exit>
  return 0; // not reached
}
8010676b:	31 c0                	xor    %eax,%eax
8010676d:	c9                   	leave  
8010676e:	c3                   	ret    
8010676f:	90                   	nop

80106770 <sys_wait>:

int sys_wait(void)
{
80106770:	55                   	push   %ebp
80106771:	89 e5                	mov    %esp,%ebp
  return wait();
}
80106773:	5d                   	pop    %ebp
  return wait();
80106774:	e9 d7 e5 ff ff       	jmp    80104d50 <wait>
80106779:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106780 <sys_waitx>:

int sys_waitx(void)
{
80106780:	55                   	push   %ebp
80106781:	89 e5                	mov    %esp,%ebp
80106783:	83 ec 1c             	sub    $0x1c,%esp
  int *wtime;
  int *rtime;

  if (argptr(0, (char **)&wtime, sizeof(int)) < 0)
80106786:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106789:	6a 04                	push   $0x4
8010678b:	50                   	push   %eax
8010678c:	6a 00                	push   $0x0
8010678e:	e8 dd f2 ff ff       	call   80105a70 <argptr>
80106793:	83 c4 10             	add    $0x10,%esp
80106796:	85 c0                	test   %eax,%eax
80106798:	78 2e                	js     801067c8 <sys_waitx+0x48>
    return -1;

  if (argptr(1, (char **)&rtime, sizeof(int)) < 0)
8010679a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010679d:	83 ec 04             	sub    $0x4,%esp
801067a0:	6a 04                	push   $0x4
801067a2:	50                   	push   %eax
801067a3:	6a 01                	push   $0x1
801067a5:	e8 c6 f2 ff ff       	call   80105a70 <argptr>
801067aa:	83 c4 10             	add    $0x10,%esp
801067ad:	85 c0                	test   %eax,%eax
801067af:	78 17                	js     801067c8 <sys_waitx+0x48>
    return -1;

  return waitx(wtime, rtime);
801067b1:	83 ec 08             	sub    $0x8,%esp
801067b4:	ff 75 f4             	pushl  -0xc(%ebp)
801067b7:	ff 75 f0             	pushl  -0x10(%ebp)
801067ba:	e8 a1 e6 ff ff       	call   80104e60 <waitx>
801067bf:	83 c4 10             	add    $0x10,%esp
}
801067c2:	c9                   	leave  
801067c3:	c3                   	ret    
801067c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801067c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801067cd:	c9                   	leave  
801067ce:	c3                   	ret    
801067cf:	90                   	nop

801067d0 <sys_kill>:

int sys_kill(void)
{
801067d0:	55                   	push   %ebp
801067d1:	89 e5                	mov    %esp,%ebp
801067d3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if (argint(0, &pid) < 0)
801067d6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801067d9:	50                   	push   %eax
801067da:	6a 00                	push   $0x0
801067dc:	e8 3f f2 ff ff       	call   80105a20 <argint>
801067e1:	83 c4 10             	add    $0x10,%esp
801067e4:	85 c0                	test   %eax,%eax
801067e6:	78 18                	js     80106800 <sys_kill+0x30>
    return -1;
  return kill(pid);
801067e8:	83 ec 0c             	sub    $0xc,%esp
801067eb:	ff 75 f4             	pushl  -0xc(%ebp)
801067ee:	e8 1d e8 ff ff       	call   80105010 <kill>
801067f3:	83 c4 10             	add    $0x10,%esp
}
801067f6:	c9                   	leave  
801067f7:	c3                   	ret    
801067f8:	90                   	nop
801067f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106800:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106805:	c9                   	leave  
80106806:	c3                   	ret    
80106807:	89 f6                	mov    %esi,%esi
80106809:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106810 <sys_getpid>:

int sys_getpid(void)
{
80106810:	55                   	push   %ebp
80106811:	89 e5                	mov    %esp,%ebp
80106813:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80106816:	e8 85 d0 ff ff       	call   801038a0 <myproc>
8010681b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010681e:	c9                   	leave  
8010681f:	c3                   	ret    

80106820 <sys_sbrk>:

int sys_sbrk(void)
{
80106820:	55                   	push   %ebp
80106821:	89 e5                	mov    %esp,%ebp
80106823:	53                   	push   %ebx
  int addr;
  int n;

  if (argint(0, &n) < 0)
80106824:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80106827:	83 ec 1c             	sub    $0x1c,%esp
  if (argint(0, &n) < 0)
8010682a:	50                   	push   %eax
8010682b:	6a 00                	push   $0x0
8010682d:	e8 ee f1 ff ff       	call   80105a20 <argint>
80106832:	83 c4 10             	add    $0x10,%esp
80106835:	85 c0                	test   %eax,%eax
80106837:	78 27                	js     80106860 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80106839:	e8 62 d0 ff ff       	call   801038a0 <myproc>
  if (growproc(n) < 0)
8010683e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80106841:	8b 18                	mov    (%eax),%ebx
  if (growproc(n) < 0)
80106843:	ff 75 f4             	pushl  -0xc(%ebp)
80106846:	e8 35 d6 ff ff       	call   80103e80 <growproc>
8010684b:	83 c4 10             	add    $0x10,%esp
8010684e:	85 c0                	test   %eax,%eax
80106850:	78 0e                	js     80106860 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80106852:	89 d8                	mov    %ebx,%eax
80106854:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106857:	c9                   	leave  
80106858:	c3                   	ret    
80106859:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106860:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80106865:	eb eb                	jmp    80106852 <sys_sbrk+0x32>
80106867:	89 f6                	mov    %esi,%esi
80106869:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106870 <sys_sleep>:

int sys_sleep(void)
{
80106870:	55                   	push   %ebp
80106871:	89 e5                	mov    %esp,%ebp
80106873:	53                   	push   %ebx
  int n;
  uint ticks0;

  if (argint(0, &n) < 0)
80106874:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80106877:	83 ec 1c             	sub    $0x1c,%esp
  if (argint(0, &n) < 0)
8010687a:	50                   	push   %eax
8010687b:	6a 00                	push   $0x0
8010687d:	e8 9e f1 ff ff       	call   80105a20 <argint>
80106882:	83 c4 10             	add    $0x10,%esp
80106885:	85 c0                	test   %eax,%eax
80106887:	0f 88 8a 00 00 00    	js     80106917 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
8010688d:	83 ec 0c             	sub    $0xc,%esp
80106890:	68 80 81 11 80       	push   $0x80118180
80106895:	e8 76 ed ff ff       	call   80105610 <acquire>
  ticks0 = ticks;
  while (ticks - ticks0 < n)
8010689a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010689d:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
801068a0:	8b 1d c0 89 11 80    	mov    0x801189c0,%ebx
  while (ticks - ticks0 < n)
801068a6:	85 d2                	test   %edx,%edx
801068a8:	75 27                	jne    801068d1 <sys_sleep+0x61>
801068aa:	eb 54                	jmp    80106900 <sys_sleep+0x90>
801068ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (myproc()->killed)
    {
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
801068b0:	83 ec 08             	sub    $0x8,%esp
801068b3:	68 80 81 11 80       	push   $0x80118180
801068b8:	68 c0 89 11 80       	push   $0x801189c0
801068bd:	e8 ce e3 ff ff       	call   80104c90 <sleep>
  while (ticks - ticks0 < n)
801068c2:	a1 c0 89 11 80       	mov    0x801189c0,%eax
801068c7:	83 c4 10             	add    $0x10,%esp
801068ca:	29 d8                	sub    %ebx,%eax
801068cc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801068cf:	73 2f                	jae    80106900 <sys_sleep+0x90>
    if (myproc()->killed)
801068d1:	e8 ca cf ff ff       	call   801038a0 <myproc>
801068d6:	8b 40 24             	mov    0x24(%eax),%eax
801068d9:	85 c0                	test   %eax,%eax
801068db:	74 d3                	je     801068b0 <sys_sleep+0x40>
      release(&tickslock);
801068dd:	83 ec 0c             	sub    $0xc,%esp
801068e0:	68 80 81 11 80       	push   $0x80118180
801068e5:	e8 e6 ed ff ff       	call   801056d0 <release>
      return -1;
801068ea:	83 c4 10             	add    $0x10,%esp
801068ed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
801068f2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801068f5:	c9                   	leave  
801068f6:	c3                   	ret    
801068f7:	89 f6                	mov    %esi,%esi
801068f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  release(&tickslock);
80106900:	83 ec 0c             	sub    $0xc,%esp
80106903:	68 80 81 11 80       	push   $0x80118180
80106908:	e8 c3 ed ff ff       	call   801056d0 <release>
  return 0;
8010690d:	83 c4 10             	add    $0x10,%esp
80106910:	31 c0                	xor    %eax,%eax
}
80106912:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106915:	c9                   	leave  
80106916:	c3                   	ret    
    return -1;
80106917:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010691c:	eb f4                	jmp    80106912 <sys_sleep+0xa2>
8010691e:	66 90                	xchg   %ax,%ax

80106920 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int sys_uptime(void)
{
80106920:	55                   	push   %ebp
80106921:	89 e5                	mov    %esp,%ebp
80106923:	53                   	push   %ebx
80106924:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80106927:	68 80 81 11 80       	push   $0x80118180
8010692c:	e8 df ec ff ff       	call   80105610 <acquire>
  xticks = ticks;
80106931:	8b 1d c0 89 11 80    	mov    0x801189c0,%ebx
  release(&tickslock);
80106937:	c7 04 24 80 81 11 80 	movl   $0x80118180,(%esp)
8010693e:	e8 8d ed ff ff       	call   801056d0 <release>
  return xticks;
}
80106943:	89 d8                	mov    %ebx,%eax
80106945:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106948:	c9                   	leave  
80106949:	c3                   	ret    
8010694a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106950 <sys_getpinfo>:

int sys_getpinfo(void)
{
80106950:	55                   	push   %ebp
80106951:	89 e5                	mov    %esp,%ebp
80106953:	83 ec 1c             	sub    $0x1c,%esp
  int pid;
  struct proc_stat *proc;

  if (argptr(0, (char **)&proc, sizeof(struct proc_stat)) < 0)
80106956:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106959:	6a 28                	push   $0x28
8010695b:	50                   	push   %eax
8010695c:	6a 00                	push   $0x0
8010695e:	e8 0d f1 ff ff       	call   80105a70 <argptr>
80106963:	83 c4 10             	add    $0x10,%esp
80106966:	85 c0                	test   %eax,%eax
80106968:	78 2e                	js     80106998 <sys_getpinfo+0x48>
    return -1;
  if (argint(1, &pid) < 0)
8010696a:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010696d:	83 ec 08             	sub    $0x8,%esp
80106970:	50                   	push   %eax
80106971:	6a 01                	push   $0x1
80106973:	e8 a8 f0 ff ff       	call   80105a20 <argint>
80106978:	83 c4 10             	add    $0x10,%esp
8010697b:	85 c0                	test   %eax,%eax
8010697d:	78 19                	js     80106998 <sys_getpinfo+0x48>
    return -1;
  return getpinfo(proc, pid);
8010697f:	83 ec 08             	sub    $0x8,%esp
80106982:	ff 75 f0             	pushl  -0x10(%ebp)
80106985:	ff 75 f4             	pushl  -0xc(%ebp)
80106988:	e8 d3 e7 ff ff       	call   80105160 <getpinfo>
8010698d:	83 c4 10             	add    $0x10,%esp
}
80106990:	c9                   	leave  
80106991:	c3                   	ret    
80106992:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80106998:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010699d:	c9                   	leave  
8010699e:	c3                   	ret    
8010699f:	90                   	nop

801069a0 <sys_ps>:

int 
sys_ps(void)
{
801069a0:	55                   	push   %ebp
801069a1:	89 e5                	mov    %esp,%ebp
  return ps();
}
801069a3:	5d                   	pop    %ebp
  return ps();
801069a4:	e9 87 e8 ff ff       	jmp    80105230 <ps>
801069a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801069b0 <sys_set_priority>:

int 
sys_set_priority(void)
{
801069b0:	55                   	push   %ebp
801069b1:	89 e5                	mov    %esp,%ebp
801069b3:	83 ec 20             	sub    $0x20,%esp
  int pid, priority;
  if(argint(0,&pid)<0)
801069b6:	8d 45 f0             	lea    -0x10(%ebp),%eax
801069b9:	50                   	push   %eax
801069ba:	6a 00                	push   $0x0
801069bc:	e8 5f f0 ff ff       	call   80105a20 <argint>
801069c1:	83 c4 10             	add    $0x10,%esp
801069c4:	85 c0                	test   %eax,%eax
801069c6:	78 28                	js     801069f0 <sys_set_priority+0x40>
    return -1;
  if(argint(1,&priority)<0)
801069c8:	8d 45 f4             	lea    -0xc(%ebp),%eax
801069cb:	83 ec 08             	sub    $0x8,%esp
801069ce:	50                   	push   %eax
801069cf:	6a 01                	push   $0x1
801069d1:	e8 4a f0 ff ff       	call   80105a20 <argint>
801069d6:	83 c4 10             	add    $0x10,%esp
801069d9:	85 c0                	test   %eax,%eax
801069db:	78 13                	js     801069f0 <sys_set_priority+0x40>
    return -1;
  return set_priority(pid, priority);
801069dd:	83 ec 08             	sub    $0x8,%esp
801069e0:	ff 75 f4             	pushl  -0xc(%ebp)
801069e3:	ff 75 f0             	pushl  -0x10(%ebp)
801069e6:	e8 35 e9 ff ff       	call   80105320 <set_priority>
801069eb:	83 c4 10             	add    $0x10,%esp
801069ee:	c9                   	leave  
801069ef:	c3                   	ret    
    return -1;
801069f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801069f5:	c9                   	leave  
801069f6:	c3                   	ret    

801069f7 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
801069f7:	1e                   	push   %ds
  pushl %es
801069f8:	06                   	push   %es
  pushl %fs
801069f9:	0f a0                	push   %fs
  pushl %gs
801069fb:	0f a8                	push   %gs
  pushal
801069fd:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
801069fe:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106a02:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106a04:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80106a06:	54                   	push   %esp
  call trap
80106a07:	e8 c4 00 00 00       	call   80106ad0 <trap>
  addl $4, %esp
80106a0c:	83 c4 04             	add    $0x4,%esp

80106a0f <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106a0f:	61                   	popa   
  popl %gs
80106a10:	0f a9                	pop    %gs
  popl %fs
80106a12:	0f a1                	pop    %fs
  popl %es
80106a14:	07                   	pop    %es
  popl %ds
80106a15:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106a16:	83 c4 08             	add    $0x8,%esp
  iret
80106a19:	cf                   	iret   
80106a1a:	66 90                	xchg   %ax,%ax
80106a1c:	66 90                	xchg   %ax,%ax
80106a1e:	66 90                	xchg   %ax,%ax

80106a20 <tvinit>:
extern uint vectors[]; // in vectors.S: array of 256 entry pointers
struct spinlock tickslock;
uint ticks;

void tvinit(void)
{
80106a20:	55                   	push   %ebp
  int i;

  for (i = 0; i < 256; i++)
80106a21:	31 c0                	xor    %eax,%eax
{
80106a23:	89 e5                	mov    %esp,%ebp
80106a25:	83 ec 08             	sub    $0x8,%esp
80106a28:	90                   	nop
80106a29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE << 3, vectors[i], 0);
80106a30:	8b 14 85 30 c0 10 80 	mov    -0x7fef3fd0(,%eax,4),%edx
80106a37:	c7 04 c5 c2 81 11 80 	movl   $0x8e000008,-0x7fee7e3e(,%eax,8)
80106a3e:	08 00 00 8e 
80106a42:	66 89 14 c5 c0 81 11 	mov    %dx,-0x7fee7e40(,%eax,8)
80106a49:	80 
80106a4a:	c1 ea 10             	shr    $0x10,%edx
80106a4d:	66 89 14 c5 c6 81 11 	mov    %dx,-0x7fee7e3a(,%eax,8)
80106a54:	80 
  for (i = 0; i < 256; i++)
80106a55:	83 c0 01             	add    $0x1,%eax
80106a58:	3d 00 01 00 00       	cmp    $0x100,%eax
80106a5d:	75 d1                	jne    80106a30 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE << 3, vectors[T_SYSCALL], DPL_USER);
80106a5f:	a1 30 c1 10 80       	mov    0x8010c130,%eax

  initlock(&tickslock, "time");
80106a64:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE << 3, vectors[T_SYSCALL], DPL_USER);
80106a67:	c7 05 c2 83 11 80 08 	movl   $0xef000008,0x801183c2
80106a6e:	00 00 ef 
  initlock(&tickslock, "time");
80106a71:	68 49 8e 10 80       	push   $0x80108e49
80106a76:	68 80 81 11 80       	push   $0x80118180
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE << 3, vectors[T_SYSCALL], DPL_USER);
80106a7b:	66 a3 c0 83 11 80    	mov    %ax,0x801183c0
80106a81:	c1 e8 10             	shr    $0x10,%eax
80106a84:	66 a3 c6 83 11 80    	mov    %ax,0x801183c6
  initlock(&tickslock, "time");
80106a8a:	e8 41 ea ff ff       	call   801054d0 <initlock>
}
80106a8f:	83 c4 10             	add    $0x10,%esp
80106a92:	c9                   	leave  
80106a93:	c3                   	ret    
80106a94:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106a9a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106aa0 <idtinit>:

void idtinit(void)
{
80106aa0:	55                   	push   %ebp
  pd[0] = size-1;
80106aa1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80106aa6:	89 e5                	mov    %esp,%ebp
80106aa8:	83 ec 10             	sub    $0x10,%esp
80106aab:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106aaf:	b8 c0 81 11 80       	mov    $0x801181c0,%eax
80106ab4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106ab8:	c1 e8 10             	shr    $0x10,%eax
80106abb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80106abf:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106ac2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80106ac5:	c9                   	leave  
80106ac6:	c3                   	ret    
80106ac7:	89 f6                	mov    %esi,%esi
80106ac9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106ad0 <trap>:

//PAGEBREAK: 41
void trap(struct trapframe *tf)
{
80106ad0:	55                   	push   %ebp
80106ad1:	89 e5                	mov    %esp,%ebp
80106ad3:	57                   	push   %edi
80106ad4:	56                   	push   %esi
80106ad5:	53                   	push   %ebx
80106ad6:	83 ec 1c             	sub    $0x1c,%esp
80106ad9:	8b 7d 08             	mov    0x8(%ebp),%edi
  struct proc *proc = myproc();
80106adc:	e8 bf cd ff ff       	call   801038a0 <myproc>
80106ae1:	89 c3                	mov    %eax,%ebx
  if (tf->trapno == T_SYSCALL)
80106ae3:	8b 47 30             	mov    0x30(%edi),%eax
80106ae6:	83 f8 40             	cmp    $0x40,%eax
80106ae9:	0f 84 e9 00 00 00    	je     80106bd8 <trap+0x108>
    if (myproc()->killed)
      exit();
    return;
  }

  switch (tf->trapno)
80106aef:	83 e8 20             	sub    $0x20,%eax
80106af2:	83 f8 1f             	cmp    $0x1f,%eax
80106af5:	77 09                	ja     80106b00 <trap+0x30>
80106af7:	ff 24 85 00 8f 10 80 	jmp    *-0x7fef7100(,%eax,4)
80106afe:	66 90                	xchg   %ax,%ax
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if (myproc() == 0 || (tf->cs & 3) == 0)
80106b00:	e8 9b cd ff ff       	call   801038a0 <myproc>
80106b05:	85 c0                	test   %eax,%eax
80106b07:	0f 84 5f 02 00 00    	je     80106d6c <trap+0x29c>
80106b0d:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80106b11:	0f 84 55 02 00 00    	je     80106d6c <trap+0x29c>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106b17:	0f 20 d1             	mov    %cr2,%ecx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106b1a:	8b 57 38             	mov    0x38(%edi),%edx
80106b1d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
80106b20:	89 55 dc             	mov    %edx,-0x24(%ebp)
80106b23:	e8 58 cd ff ff       	call   80103880 <cpuid>
80106b28:	8b 77 34             	mov    0x34(%edi),%esi
80106b2b:	8b 5f 30             	mov    0x30(%edi),%ebx
80106b2e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80106b31:	e8 6a cd ff ff       	call   801038a0 <myproc>
80106b36:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106b39:	e8 62 cd ff ff       	call   801038a0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106b3e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80106b41:	8b 55 dc             	mov    -0x24(%ebp),%edx
80106b44:	51                   	push   %ecx
80106b45:	52                   	push   %edx
            myproc()->pid, myproc()->name, tf->trapno,
80106b46:	8b 55 e0             	mov    -0x20(%ebp),%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106b49:	ff 75 e4             	pushl  -0x1c(%ebp)
80106b4c:	56                   	push   %esi
80106b4d:	53                   	push   %ebx
            myproc()->pid, myproc()->name, tf->trapno,
80106b4e:	83 c2 6c             	add    $0x6c,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106b51:	52                   	push   %edx
80106b52:	ff 70 10             	pushl  0x10(%eax)
80106b55:	68 bc 8e 10 80       	push   $0x80108ebc
80106b5a:	e8 01 9b ff ff       	call   80100660 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80106b5f:	83 c4 20             	add    $0x20,%esp
80106b62:	e8 39 cd ff ff       	call   801038a0 <myproc>
80106b67:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
80106b6e:	e8 2d cd ff ff       	call   801038a0 <myproc>
80106b73:	85 c0                	test   %eax,%eax
80106b75:	74 1d                	je     80106b94 <trap+0xc4>
80106b77:	e8 24 cd ff ff       	call   801038a0 <myproc>
80106b7c:	8b 50 24             	mov    0x24(%eax),%edx
80106b7f:	85 d2                	test   %edx,%edx
80106b81:	74 11                	je     80106b94 <trap+0xc4>
80106b83:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80106b87:	83 e0 03             	and    $0x3,%eax
80106b8a:	66 83 f8 03          	cmp    $0x3,%ax
80106b8e:	0f 84 4c 01 00 00    	je     80106ce0 <trap+0x210>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if (myproc() && myproc()->state == RUNNING && tf->trapno == T_IRQ0 + IRQ_TIMER)
80106b94:	e8 07 cd ff ff       	call   801038a0 <myproc>
80106b99:	85 c0                	test   %eax,%eax
80106b9b:	74 0b                	je     80106ba8 <trap+0xd8>
80106b9d:	e8 fe cc ff ff       	call   801038a0 <myproc>
80106ba2:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80106ba6:	74 68                	je     80106c10 <trap+0x140>
    #endif
    #endif
    #endif
  }
  // Check if the process has been killed since we yielded
  if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
80106ba8:	e8 f3 cc ff ff       	call   801038a0 <myproc>
80106bad:	85 c0                	test   %eax,%eax
80106baf:	74 19                	je     80106bca <trap+0xfa>
80106bb1:	e8 ea cc ff ff       	call   801038a0 <myproc>
80106bb6:	8b 40 24             	mov    0x24(%eax),%eax
80106bb9:	85 c0                	test   %eax,%eax
80106bbb:	74 0d                	je     80106bca <trap+0xfa>
80106bbd:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80106bc1:	83 e0 03             	and    $0x3,%eax
80106bc4:	66 83 f8 03          	cmp    $0x3,%ax
80106bc8:	74 37                	je     80106c01 <trap+0x131>
    exit();
}
80106bca:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106bcd:	5b                   	pop    %ebx
80106bce:	5e                   	pop    %esi
80106bcf:	5f                   	pop    %edi
80106bd0:	5d                   	pop    %ebp
80106bd1:	c3                   	ret    
80106bd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if (myproc()->killed)
80106bd8:	e8 c3 cc ff ff       	call   801038a0 <myproc>
80106bdd:	8b 58 24             	mov    0x24(%eax),%ebx
80106be0:	85 db                	test   %ebx,%ebx
80106be2:	0f 85 e8 00 00 00    	jne    80106cd0 <trap+0x200>
    myproc()->tf = tf;
80106be8:	e8 b3 cc ff ff       	call   801038a0 <myproc>
80106bed:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
80106bf0:	e8 1b ef ff ff       	call   80105b10 <syscall>
    if (myproc()->killed)
80106bf5:	e8 a6 cc ff ff       	call   801038a0 <myproc>
80106bfa:	8b 48 24             	mov    0x24(%eax),%ecx
80106bfd:	85 c9                	test   %ecx,%ecx
80106bff:	74 c9                	je     80106bca <trap+0xfa>
}
80106c01:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c04:	5b                   	pop    %ebx
80106c05:	5e                   	pop    %esi
80106c06:	5f                   	pop    %edi
80106c07:	5d                   	pop    %ebp
      exit();
80106c08:	e9 f3 de ff ff       	jmp    80104b00 <exit>
80106c0d:	8d 76 00             	lea    0x0(%esi),%esi
  if (myproc() && myproc()->state == RUNNING && tf->trapno == T_IRQ0 + IRQ_TIMER)
80106c10:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
80106c14:	75 92                	jne    80106ba8 <trap+0xd8>
        yield();
80106c16:	e8 25 e0 ff ff       	call   80104c40 <yield>
80106c1b:	eb 8b                	jmp    80106ba8 <trap+0xd8>
80106c1d:	8d 76 00             	lea    0x0(%esi),%esi
    if (cpuid() == 0)
80106c20:	e8 5b cc ff ff       	call   80103880 <cpuid>
80106c25:	85 c0                	test   %eax,%eax
80106c27:	0f 84 c3 00 00 00    	je     80106cf0 <trap+0x220>
    lapiceoi();
80106c2d:	e8 1e bb ff ff       	call   80102750 <lapiceoi>
  if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
80106c32:	e8 69 cc ff ff       	call   801038a0 <myproc>
80106c37:	85 c0                	test   %eax,%eax
80106c39:	0f 85 38 ff ff ff    	jne    80106b77 <trap+0xa7>
80106c3f:	e9 50 ff ff ff       	jmp    80106b94 <trap+0xc4>
80106c44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80106c48:	e8 c3 b9 ff ff       	call   80102610 <kbdintr>
    lapiceoi();
80106c4d:	e8 fe ba ff ff       	call   80102750 <lapiceoi>
  if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
80106c52:	e8 49 cc ff ff       	call   801038a0 <myproc>
80106c57:	85 c0                	test   %eax,%eax
80106c59:	0f 85 18 ff ff ff    	jne    80106b77 <trap+0xa7>
80106c5f:	e9 30 ff ff ff       	jmp    80106b94 <trap+0xc4>
80106c64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80106c68:	e8 d3 02 00 00       	call   80106f40 <uartintr>
    lapiceoi();
80106c6d:	e8 de ba ff ff       	call   80102750 <lapiceoi>
  if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
80106c72:	e8 29 cc ff ff       	call   801038a0 <myproc>
80106c77:	85 c0                	test   %eax,%eax
80106c79:	0f 85 f8 fe ff ff    	jne    80106b77 <trap+0xa7>
80106c7f:	e9 10 ff ff ff       	jmp    80106b94 <trap+0xc4>
80106c84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106c88:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
80106c8c:	8b 77 38             	mov    0x38(%edi),%esi
80106c8f:	e8 ec cb ff ff       	call   80103880 <cpuid>
80106c94:	56                   	push   %esi
80106c95:	53                   	push   %ebx
80106c96:	50                   	push   %eax
80106c97:	68 64 8e 10 80       	push   $0x80108e64
80106c9c:	e8 bf 99 ff ff       	call   80100660 <cprintf>
    lapiceoi();
80106ca1:	e8 aa ba ff ff       	call   80102750 <lapiceoi>
    break;
80106ca6:	83 c4 10             	add    $0x10,%esp
  if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
80106ca9:	e8 f2 cb ff ff       	call   801038a0 <myproc>
80106cae:	85 c0                	test   %eax,%eax
80106cb0:	0f 85 c1 fe ff ff    	jne    80106b77 <trap+0xa7>
80106cb6:	e9 d9 fe ff ff       	jmp    80106b94 <trap+0xc4>
80106cbb:	90                   	nop
80106cbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ideintr();
80106cc0:	e8 bb b3 ff ff       	call   80102080 <ideintr>
80106cc5:	e9 63 ff ff ff       	jmp    80106c2d <trap+0x15d>
80106cca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80106cd0:	e8 2b de ff ff       	call   80104b00 <exit>
80106cd5:	e9 0e ff ff ff       	jmp    80106be8 <trap+0x118>
80106cda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    exit();
80106ce0:	e8 1b de ff ff       	call   80104b00 <exit>
80106ce5:	e9 aa fe ff ff       	jmp    80106b94 <trap+0xc4>
80106cea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
80106cf0:	83 ec 0c             	sub    $0xc,%esp
80106cf3:	68 80 81 11 80       	push   $0x80118180
80106cf8:	e8 13 e9 ff ff       	call   80105610 <acquire>
      wakeup(&ticks);
80106cfd:	c7 04 24 c0 89 11 80 	movl   $0x801189c0,(%esp)
      ticks++;
80106d04:	83 05 c0 89 11 80 01 	addl   $0x1,0x801189c0
      wakeup(&ticks);
80106d0b:	e8 a0 e2 ff ff       	call   80104fb0 <wakeup>
      release(&tickslock);
80106d10:	c7 04 24 80 81 11 80 	movl   $0x80118180,(%esp)
80106d17:	e8 b4 e9 ff ff       	call   801056d0 <release>
      if (proc)
80106d1c:	83 c4 10             	add    $0x10,%esp
80106d1f:	85 db                	test   %ebx,%ebx
80106d21:	0f 84 06 ff ff ff    	je     80106c2d <trap+0x15d>
        if (myproc()->state == RUNNING)
80106d27:	e8 74 cb ff ff       	call   801038a0 <myproc>
80106d2c:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80106d30:	74 16                	je     80106d48 <trap+0x278>
        else if (proc->state == SLEEPING)
80106d32:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
80106d36:	0f 85 f1 fe ff ff    	jne    80106c2d <trap+0x15d>
          proc->iotime++;
80106d3c:	83 83 88 00 00 00 01 	addl   $0x1,0x88(%ebx)
80106d43:	e9 e5 fe ff ff       	jmp    80106c2d <trap+0x15d>
          myproc()->rtime++;
80106d48:	e8 53 cb ff ff       	call   801038a0 <myproc>
80106d4d:	83 80 84 00 00 00 01 	addl   $0x1,0x84(%eax)
          myproc()->ticks[proc->current_queue]++;
80106d54:	e8 47 cb ff ff       	call   801038a0 <myproc>
80106d59:	8b 93 b8 00 00 00    	mov    0xb8(%ebx),%edx
80106d5f:	83 84 90 94 00 00 00 	addl   $0x1,0x94(%eax,%edx,4)
80106d66:	01 
80106d67:	e9 c1 fe ff ff       	jmp    80106c2d <trap+0x15d>
      if(myproc()==0)
80106d6c:	e8 2f cb ff ff       	call   801038a0 <myproc>
80106d71:	85 c0                	test   %eax,%eax
80106d73:	74 3b                	je     80106db0 <trap+0x2e0>
        cprintf("lala\n");
80106d75:	83 ec 0c             	sub    $0xc,%esp
80106d78:	68 56 8e 10 80       	push   $0x80108e56
80106d7d:	e8 de 98 ff ff       	call   80100660 <cprintf>
80106d82:	83 c4 10             	add    $0x10,%esp
80106d85:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106d88:	8b 5f 38             	mov    0x38(%edi),%ebx
80106d8b:	e8 f0 ca ff ff       	call   80103880 <cpuid>
80106d90:	83 ec 0c             	sub    $0xc,%esp
80106d93:	56                   	push   %esi
80106d94:	53                   	push   %ebx
80106d95:	50                   	push   %eax
80106d96:	ff 77 30             	pushl  0x30(%edi)
80106d99:	68 88 8e 10 80       	push   $0x80108e88
80106d9e:	e8 bd 98 ff ff       	call   80100660 <cprintf>
      panic("trap");
80106da3:	83 c4 14             	add    $0x14,%esp
80106da6:	68 5c 8e 10 80       	push   $0x80108e5c
80106dab:	e8 e0 95 ff ff       	call   80100390 <panic>
        cprintf("myproc\n");
80106db0:	83 ec 0c             	sub    $0xc,%esp
80106db3:	68 4e 8e 10 80       	push   $0x80108e4e
80106db8:	e8 a3 98 ff ff       	call   80100660 <cprintf>
80106dbd:	83 c4 10             	add    $0x10,%esp
80106dc0:	eb c3                	jmp    80106d85 <trap+0x2b5>
80106dc2:	66 90                	xchg   %ax,%ax
80106dc4:	66 90                	xchg   %ax,%ax
80106dc6:	66 90                	xchg   %ax,%ax
80106dc8:	66 90                	xchg   %ax,%ax
80106dca:	66 90                	xchg   %ax,%ax
80106dcc:	66 90                	xchg   %ax,%ax
80106dce:	66 90                	xchg   %ax,%ax

80106dd0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80106dd0:	a1 dc c5 10 80       	mov    0x8010c5dc,%eax
{
80106dd5:	55                   	push   %ebp
80106dd6:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106dd8:	85 c0                	test   %eax,%eax
80106dda:	74 1c                	je     80106df8 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106ddc:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106de1:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106de2:	a8 01                	test   $0x1,%al
80106de4:	74 12                	je     80106df8 <uartgetc+0x28>
80106de6:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106deb:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80106dec:	0f b6 c0             	movzbl %al,%eax
}
80106def:	5d                   	pop    %ebp
80106df0:	c3                   	ret    
80106df1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106df8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106dfd:	5d                   	pop    %ebp
80106dfe:	c3                   	ret    
80106dff:	90                   	nop

80106e00 <uartputc.part.0>:
uartputc(int c)
80106e00:	55                   	push   %ebp
80106e01:	89 e5                	mov    %esp,%ebp
80106e03:	57                   	push   %edi
80106e04:	56                   	push   %esi
80106e05:	53                   	push   %ebx
80106e06:	89 c7                	mov    %eax,%edi
80106e08:	bb 80 00 00 00       	mov    $0x80,%ebx
80106e0d:	be fd 03 00 00       	mov    $0x3fd,%esi
80106e12:	83 ec 0c             	sub    $0xc,%esp
80106e15:	eb 1b                	jmp    80106e32 <uartputc.part.0+0x32>
80106e17:	89 f6                	mov    %esi,%esi
80106e19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    microdelay(10);
80106e20:	83 ec 0c             	sub    $0xc,%esp
80106e23:	6a 0a                	push   $0xa
80106e25:	e8 46 b9 ff ff       	call   80102770 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106e2a:	83 c4 10             	add    $0x10,%esp
80106e2d:	83 eb 01             	sub    $0x1,%ebx
80106e30:	74 07                	je     80106e39 <uartputc.part.0+0x39>
80106e32:	89 f2                	mov    %esi,%edx
80106e34:	ec                   	in     (%dx),%al
80106e35:	a8 20                	test   $0x20,%al
80106e37:	74 e7                	je     80106e20 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106e39:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106e3e:	89 f8                	mov    %edi,%eax
80106e40:	ee                   	out    %al,(%dx)
}
80106e41:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e44:	5b                   	pop    %ebx
80106e45:	5e                   	pop    %esi
80106e46:	5f                   	pop    %edi
80106e47:	5d                   	pop    %ebp
80106e48:	c3                   	ret    
80106e49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106e50 <uartinit>:
{
80106e50:	55                   	push   %ebp
80106e51:	31 c9                	xor    %ecx,%ecx
80106e53:	89 c8                	mov    %ecx,%eax
80106e55:	89 e5                	mov    %esp,%ebp
80106e57:	57                   	push   %edi
80106e58:	56                   	push   %esi
80106e59:	53                   	push   %ebx
80106e5a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80106e5f:	89 da                	mov    %ebx,%edx
80106e61:	83 ec 0c             	sub    $0xc,%esp
80106e64:	ee                   	out    %al,(%dx)
80106e65:	bf fb 03 00 00       	mov    $0x3fb,%edi
80106e6a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80106e6f:	89 fa                	mov    %edi,%edx
80106e71:	ee                   	out    %al,(%dx)
80106e72:	b8 0c 00 00 00       	mov    $0xc,%eax
80106e77:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106e7c:	ee                   	out    %al,(%dx)
80106e7d:	be f9 03 00 00       	mov    $0x3f9,%esi
80106e82:	89 c8                	mov    %ecx,%eax
80106e84:	89 f2                	mov    %esi,%edx
80106e86:	ee                   	out    %al,(%dx)
80106e87:	b8 03 00 00 00       	mov    $0x3,%eax
80106e8c:	89 fa                	mov    %edi,%edx
80106e8e:	ee                   	out    %al,(%dx)
80106e8f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106e94:	89 c8                	mov    %ecx,%eax
80106e96:	ee                   	out    %al,(%dx)
80106e97:	b8 01 00 00 00       	mov    $0x1,%eax
80106e9c:	89 f2                	mov    %esi,%edx
80106e9e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106e9f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106ea4:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106ea5:	3c ff                	cmp    $0xff,%al
80106ea7:	74 5a                	je     80106f03 <uartinit+0xb3>
  uart = 1;
80106ea9:	c7 05 dc c5 10 80 01 	movl   $0x1,0x8010c5dc
80106eb0:	00 00 00 
80106eb3:	89 da                	mov    %ebx,%edx
80106eb5:	ec                   	in     (%dx),%al
80106eb6:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106ebb:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80106ebc:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80106ebf:	bb 80 8f 10 80       	mov    $0x80108f80,%ebx
  ioapicenable(IRQ_COM1, 0);
80106ec4:	6a 00                	push   $0x0
80106ec6:	6a 04                	push   $0x4
80106ec8:	e8 03 b4 ff ff       	call   801022d0 <ioapicenable>
80106ecd:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80106ed0:	b8 78 00 00 00       	mov    $0x78,%eax
80106ed5:	eb 13                	jmp    80106eea <uartinit+0x9a>
80106ed7:	89 f6                	mov    %esi,%esi
80106ed9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106ee0:	83 c3 01             	add    $0x1,%ebx
80106ee3:	0f be 03             	movsbl (%ebx),%eax
80106ee6:	84 c0                	test   %al,%al
80106ee8:	74 19                	je     80106f03 <uartinit+0xb3>
  if(!uart)
80106eea:	8b 15 dc c5 10 80    	mov    0x8010c5dc,%edx
80106ef0:	85 d2                	test   %edx,%edx
80106ef2:	74 ec                	je     80106ee0 <uartinit+0x90>
  for(p="xv6...\n"; *p; p++)
80106ef4:	83 c3 01             	add    $0x1,%ebx
80106ef7:	e8 04 ff ff ff       	call   80106e00 <uartputc.part.0>
80106efc:	0f be 03             	movsbl (%ebx),%eax
80106eff:	84 c0                	test   %al,%al
80106f01:	75 e7                	jne    80106eea <uartinit+0x9a>
}
80106f03:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f06:	5b                   	pop    %ebx
80106f07:	5e                   	pop    %esi
80106f08:	5f                   	pop    %edi
80106f09:	5d                   	pop    %ebp
80106f0a:	c3                   	ret    
80106f0b:	90                   	nop
80106f0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106f10 <uartputc>:
  if(!uart)
80106f10:	8b 15 dc c5 10 80    	mov    0x8010c5dc,%edx
{
80106f16:	55                   	push   %ebp
80106f17:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106f19:	85 d2                	test   %edx,%edx
{
80106f1b:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
80106f1e:	74 10                	je     80106f30 <uartputc+0x20>
}
80106f20:	5d                   	pop    %ebp
80106f21:	e9 da fe ff ff       	jmp    80106e00 <uartputc.part.0>
80106f26:	8d 76 00             	lea    0x0(%esi),%esi
80106f29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106f30:	5d                   	pop    %ebp
80106f31:	c3                   	ret    
80106f32:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106f40 <uartintr>:

void
uartintr(void)
{
80106f40:	55                   	push   %ebp
80106f41:	89 e5                	mov    %esp,%ebp
80106f43:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106f46:	68 d0 6d 10 80       	push   $0x80106dd0
80106f4b:	e8 c0 98 ff ff       	call   80100810 <consoleintr>
}
80106f50:	83 c4 10             	add    $0x10,%esp
80106f53:	c9                   	leave  
80106f54:	c3                   	ret    

80106f55 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106f55:	6a 00                	push   $0x0
  pushl $0
80106f57:	6a 00                	push   $0x0
  jmp alltraps
80106f59:	e9 99 fa ff ff       	jmp    801069f7 <alltraps>

80106f5e <vector1>:
.globl vector1
vector1:
  pushl $0
80106f5e:	6a 00                	push   $0x0
  pushl $1
80106f60:	6a 01                	push   $0x1
  jmp alltraps
80106f62:	e9 90 fa ff ff       	jmp    801069f7 <alltraps>

80106f67 <vector2>:
.globl vector2
vector2:
  pushl $0
80106f67:	6a 00                	push   $0x0
  pushl $2
80106f69:	6a 02                	push   $0x2
  jmp alltraps
80106f6b:	e9 87 fa ff ff       	jmp    801069f7 <alltraps>

80106f70 <vector3>:
.globl vector3
vector3:
  pushl $0
80106f70:	6a 00                	push   $0x0
  pushl $3
80106f72:	6a 03                	push   $0x3
  jmp alltraps
80106f74:	e9 7e fa ff ff       	jmp    801069f7 <alltraps>

80106f79 <vector4>:
.globl vector4
vector4:
  pushl $0
80106f79:	6a 00                	push   $0x0
  pushl $4
80106f7b:	6a 04                	push   $0x4
  jmp alltraps
80106f7d:	e9 75 fa ff ff       	jmp    801069f7 <alltraps>

80106f82 <vector5>:
.globl vector5
vector5:
  pushl $0
80106f82:	6a 00                	push   $0x0
  pushl $5
80106f84:	6a 05                	push   $0x5
  jmp alltraps
80106f86:	e9 6c fa ff ff       	jmp    801069f7 <alltraps>

80106f8b <vector6>:
.globl vector6
vector6:
  pushl $0
80106f8b:	6a 00                	push   $0x0
  pushl $6
80106f8d:	6a 06                	push   $0x6
  jmp alltraps
80106f8f:	e9 63 fa ff ff       	jmp    801069f7 <alltraps>

80106f94 <vector7>:
.globl vector7
vector7:
  pushl $0
80106f94:	6a 00                	push   $0x0
  pushl $7
80106f96:	6a 07                	push   $0x7
  jmp alltraps
80106f98:	e9 5a fa ff ff       	jmp    801069f7 <alltraps>

80106f9d <vector8>:
.globl vector8
vector8:
  pushl $8
80106f9d:	6a 08                	push   $0x8
  jmp alltraps
80106f9f:	e9 53 fa ff ff       	jmp    801069f7 <alltraps>

80106fa4 <vector9>:
.globl vector9
vector9:
  pushl $0
80106fa4:	6a 00                	push   $0x0
  pushl $9
80106fa6:	6a 09                	push   $0x9
  jmp alltraps
80106fa8:	e9 4a fa ff ff       	jmp    801069f7 <alltraps>

80106fad <vector10>:
.globl vector10
vector10:
  pushl $10
80106fad:	6a 0a                	push   $0xa
  jmp alltraps
80106faf:	e9 43 fa ff ff       	jmp    801069f7 <alltraps>

80106fb4 <vector11>:
.globl vector11
vector11:
  pushl $11
80106fb4:	6a 0b                	push   $0xb
  jmp alltraps
80106fb6:	e9 3c fa ff ff       	jmp    801069f7 <alltraps>

80106fbb <vector12>:
.globl vector12
vector12:
  pushl $12
80106fbb:	6a 0c                	push   $0xc
  jmp alltraps
80106fbd:	e9 35 fa ff ff       	jmp    801069f7 <alltraps>

80106fc2 <vector13>:
.globl vector13
vector13:
  pushl $13
80106fc2:	6a 0d                	push   $0xd
  jmp alltraps
80106fc4:	e9 2e fa ff ff       	jmp    801069f7 <alltraps>

80106fc9 <vector14>:
.globl vector14
vector14:
  pushl $14
80106fc9:	6a 0e                	push   $0xe
  jmp alltraps
80106fcb:	e9 27 fa ff ff       	jmp    801069f7 <alltraps>

80106fd0 <vector15>:
.globl vector15
vector15:
  pushl $0
80106fd0:	6a 00                	push   $0x0
  pushl $15
80106fd2:	6a 0f                	push   $0xf
  jmp alltraps
80106fd4:	e9 1e fa ff ff       	jmp    801069f7 <alltraps>

80106fd9 <vector16>:
.globl vector16
vector16:
  pushl $0
80106fd9:	6a 00                	push   $0x0
  pushl $16
80106fdb:	6a 10                	push   $0x10
  jmp alltraps
80106fdd:	e9 15 fa ff ff       	jmp    801069f7 <alltraps>

80106fe2 <vector17>:
.globl vector17
vector17:
  pushl $17
80106fe2:	6a 11                	push   $0x11
  jmp alltraps
80106fe4:	e9 0e fa ff ff       	jmp    801069f7 <alltraps>

80106fe9 <vector18>:
.globl vector18
vector18:
  pushl $0
80106fe9:	6a 00                	push   $0x0
  pushl $18
80106feb:	6a 12                	push   $0x12
  jmp alltraps
80106fed:	e9 05 fa ff ff       	jmp    801069f7 <alltraps>

80106ff2 <vector19>:
.globl vector19
vector19:
  pushl $0
80106ff2:	6a 00                	push   $0x0
  pushl $19
80106ff4:	6a 13                	push   $0x13
  jmp alltraps
80106ff6:	e9 fc f9 ff ff       	jmp    801069f7 <alltraps>

80106ffb <vector20>:
.globl vector20
vector20:
  pushl $0
80106ffb:	6a 00                	push   $0x0
  pushl $20
80106ffd:	6a 14                	push   $0x14
  jmp alltraps
80106fff:	e9 f3 f9 ff ff       	jmp    801069f7 <alltraps>

80107004 <vector21>:
.globl vector21
vector21:
  pushl $0
80107004:	6a 00                	push   $0x0
  pushl $21
80107006:	6a 15                	push   $0x15
  jmp alltraps
80107008:	e9 ea f9 ff ff       	jmp    801069f7 <alltraps>

8010700d <vector22>:
.globl vector22
vector22:
  pushl $0
8010700d:	6a 00                	push   $0x0
  pushl $22
8010700f:	6a 16                	push   $0x16
  jmp alltraps
80107011:	e9 e1 f9 ff ff       	jmp    801069f7 <alltraps>

80107016 <vector23>:
.globl vector23
vector23:
  pushl $0
80107016:	6a 00                	push   $0x0
  pushl $23
80107018:	6a 17                	push   $0x17
  jmp alltraps
8010701a:	e9 d8 f9 ff ff       	jmp    801069f7 <alltraps>

8010701f <vector24>:
.globl vector24
vector24:
  pushl $0
8010701f:	6a 00                	push   $0x0
  pushl $24
80107021:	6a 18                	push   $0x18
  jmp alltraps
80107023:	e9 cf f9 ff ff       	jmp    801069f7 <alltraps>

80107028 <vector25>:
.globl vector25
vector25:
  pushl $0
80107028:	6a 00                	push   $0x0
  pushl $25
8010702a:	6a 19                	push   $0x19
  jmp alltraps
8010702c:	e9 c6 f9 ff ff       	jmp    801069f7 <alltraps>

80107031 <vector26>:
.globl vector26
vector26:
  pushl $0
80107031:	6a 00                	push   $0x0
  pushl $26
80107033:	6a 1a                	push   $0x1a
  jmp alltraps
80107035:	e9 bd f9 ff ff       	jmp    801069f7 <alltraps>

8010703a <vector27>:
.globl vector27
vector27:
  pushl $0
8010703a:	6a 00                	push   $0x0
  pushl $27
8010703c:	6a 1b                	push   $0x1b
  jmp alltraps
8010703e:	e9 b4 f9 ff ff       	jmp    801069f7 <alltraps>

80107043 <vector28>:
.globl vector28
vector28:
  pushl $0
80107043:	6a 00                	push   $0x0
  pushl $28
80107045:	6a 1c                	push   $0x1c
  jmp alltraps
80107047:	e9 ab f9 ff ff       	jmp    801069f7 <alltraps>

8010704c <vector29>:
.globl vector29
vector29:
  pushl $0
8010704c:	6a 00                	push   $0x0
  pushl $29
8010704e:	6a 1d                	push   $0x1d
  jmp alltraps
80107050:	e9 a2 f9 ff ff       	jmp    801069f7 <alltraps>

80107055 <vector30>:
.globl vector30
vector30:
  pushl $0
80107055:	6a 00                	push   $0x0
  pushl $30
80107057:	6a 1e                	push   $0x1e
  jmp alltraps
80107059:	e9 99 f9 ff ff       	jmp    801069f7 <alltraps>

8010705e <vector31>:
.globl vector31
vector31:
  pushl $0
8010705e:	6a 00                	push   $0x0
  pushl $31
80107060:	6a 1f                	push   $0x1f
  jmp alltraps
80107062:	e9 90 f9 ff ff       	jmp    801069f7 <alltraps>

80107067 <vector32>:
.globl vector32
vector32:
  pushl $0
80107067:	6a 00                	push   $0x0
  pushl $32
80107069:	6a 20                	push   $0x20
  jmp alltraps
8010706b:	e9 87 f9 ff ff       	jmp    801069f7 <alltraps>

80107070 <vector33>:
.globl vector33
vector33:
  pushl $0
80107070:	6a 00                	push   $0x0
  pushl $33
80107072:	6a 21                	push   $0x21
  jmp alltraps
80107074:	e9 7e f9 ff ff       	jmp    801069f7 <alltraps>

80107079 <vector34>:
.globl vector34
vector34:
  pushl $0
80107079:	6a 00                	push   $0x0
  pushl $34
8010707b:	6a 22                	push   $0x22
  jmp alltraps
8010707d:	e9 75 f9 ff ff       	jmp    801069f7 <alltraps>

80107082 <vector35>:
.globl vector35
vector35:
  pushl $0
80107082:	6a 00                	push   $0x0
  pushl $35
80107084:	6a 23                	push   $0x23
  jmp alltraps
80107086:	e9 6c f9 ff ff       	jmp    801069f7 <alltraps>

8010708b <vector36>:
.globl vector36
vector36:
  pushl $0
8010708b:	6a 00                	push   $0x0
  pushl $36
8010708d:	6a 24                	push   $0x24
  jmp alltraps
8010708f:	e9 63 f9 ff ff       	jmp    801069f7 <alltraps>

80107094 <vector37>:
.globl vector37
vector37:
  pushl $0
80107094:	6a 00                	push   $0x0
  pushl $37
80107096:	6a 25                	push   $0x25
  jmp alltraps
80107098:	e9 5a f9 ff ff       	jmp    801069f7 <alltraps>

8010709d <vector38>:
.globl vector38
vector38:
  pushl $0
8010709d:	6a 00                	push   $0x0
  pushl $38
8010709f:	6a 26                	push   $0x26
  jmp alltraps
801070a1:	e9 51 f9 ff ff       	jmp    801069f7 <alltraps>

801070a6 <vector39>:
.globl vector39
vector39:
  pushl $0
801070a6:	6a 00                	push   $0x0
  pushl $39
801070a8:	6a 27                	push   $0x27
  jmp alltraps
801070aa:	e9 48 f9 ff ff       	jmp    801069f7 <alltraps>

801070af <vector40>:
.globl vector40
vector40:
  pushl $0
801070af:	6a 00                	push   $0x0
  pushl $40
801070b1:	6a 28                	push   $0x28
  jmp alltraps
801070b3:	e9 3f f9 ff ff       	jmp    801069f7 <alltraps>

801070b8 <vector41>:
.globl vector41
vector41:
  pushl $0
801070b8:	6a 00                	push   $0x0
  pushl $41
801070ba:	6a 29                	push   $0x29
  jmp alltraps
801070bc:	e9 36 f9 ff ff       	jmp    801069f7 <alltraps>

801070c1 <vector42>:
.globl vector42
vector42:
  pushl $0
801070c1:	6a 00                	push   $0x0
  pushl $42
801070c3:	6a 2a                	push   $0x2a
  jmp alltraps
801070c5:	e9 2d f9 ff ff       	jmp    801069f7 <alltraps>

801070ca <vector43>:
.globl vector43
vector43:
  pushl $0
801070ca:	6a 00                	push   $0x0
  pushl $43
801070cc:	6a 2b                	push   $0x2b
  jmp alltraps
801070ce:	e9 24 f9 ff ff       	jmp    801069f7 <alltraps>

801070d3 <vector44>:
.globl vector44
vector44:
  pushl $0
801070d3:	6a 00                	push   $0x0
  pushl $44
801070d5:	6a 2c                	push   $0x2c
  jmp alltraps
801070d7:	e9 1b f9 ff ff       	jmp    801069f7 <alltraps>

801070dc <vector45>:
.globl vector45
vector45:
  pushl $0
801070dc:	6a 00                	push   $0x0
  pushl $45
801070de:	6a 2d                	push   $0x2d
  jmp alltraps
801070e0:	e9 12 f9 ff ff       	jmp    801069f7 <alltraps>

801070e5 <vector46>:
.globl vector46
vector46:
  pushl $0
801070e5:	6a 00                	push   $0x0
  pushl $46
801070e7:	6a 2e                	push   $0x2e
  jmp alltraps
801070e9:	e9 09 f9 ff ff       	jmp    801069f7 <alltraps>

801070ee <vector47>:
.globl vector47
vector47:
  pushl $0
801070ee:	6a 00                	push   $0x0
  pushl $47
801070f0:	6a 2f                	push   $0x2f
  jmp alltraps
801070f2:	e9 00 f9 ff ff       	jmp    801069f7 <alltraps>

801070f7 <vector48>:
.globl vector48
vector48:
  pushl $0
801070f7:	6a 00                	push   $0x0
  pushl $48
801070f9:	6a 30                	push   $0x30
  jmp alltraps
801070fb:	e9 f7 f8 ff ff       	jmp    801069f7 <alltraps>

80107100 <vector49>:
.globl vector49
vector49:
  pushl $0
80107100:	6a 00                	push   $0x0
  pushl $49
80107102:	6a 31                	push   $0x31
  jmp alltraps
80107104:	e9 ee f8 ff ff       	jmp    801069f7 <alltraps>

80107109 <vector50>:
.globl vector50
vector50:
  pushl $0
80107109:	6a 00                	push   $0x0
  pushl $50
8010710b:	6a 32                	push   $0x32
  jmp alltraps
8010710d:	e9 e5 f8 ff ff       	jmp    801069f7 <alltraps>

80107112 <vector51>:
.globl vector51
vector51:
  pushl $0
80107112:	6a 00                	push   $0x0
  pushl $51
80107114:	6a 33                	push   $0x33
  jmp alltraps
80107116:	e9 dc f8 ff ff       	jmp    801069f7 <alltraps>

8010711b <vector52>:
.globl vector52
vector52:
  pushl $0
8010711b:	6a 00                	push   $0x0
  pushl $52
8010711d:	6a 34                	push   $0x34
  jmp alltraps
8010711f:	e9 d3 f8 ff ff       	jmp    801069f7 <alltraps>

80107124 <vector53>:
.globl vector53
vector53:
  pushl $0
80107124:	6a 00                	push   $0x0
  pushl $53
80107126:	6a 35                	push   $0x35
  jmp alltraps
80107128:	e9 ca f8 ff ff       	jmp    801069f7 <alltraps>

8010712d <vector54>:
.globl vector54
vector54:
  pushl $0
8010712d:	6a 00                	push   $0x0
  pushl $54
8010712f:	6a 36                	push   $0x36
  jmp alltraps
80107131:	e9 c1 f8 ff ff       	jmp    801069f7 <alltraps>

80107136 <vector55>:
.globl vector55
vector55:
  pushl $0
80107136:	6a 00                	push   $0x0
  pushl $55
80107138:	6a 37                	push   $0x37
  jmp alltraps
8010713a:	e9 b8 f8 ff ff       	jmp    801069f7 <alltraps>

8010713f <vector56>:
.globl vector56
vector56:
  pushl $0
8010713f:	6a 00                	push   $0x0
  pushl $56
80107141:	6a 38                	push   $0x38
  jmp alltraps
80107143:	e9 af f8 ff ff       	jmp    801069f7 <alltraps>

80107148 <vector57>:
.globl vector57
vector57:
  pushl $0
80107148:	6a 00                	push   $0x0
  pushl $57
8010714a:	6a 39                	push   $0x39
  jmp alltraps
8010714c:	e9 a6 f8 ff ff       	jmp    801069f7 <alltraps>

80107151 <vector58>:
.globl vector58
vector58:
  pushl $0
80107151:	6a 00                	push   $0x0
  pushl $58
80107153:	6a 3a                	push   $0x3a
  jmp alltraps
80107155:	e9 9d f8 ff ff       	jmp    801069f7 <alltraps>

8010715a <vector59>:
.globl vector59
vector59:
  pushl $0
8010715a:	6a 00                	push   $0x0
  pushl $59
8010715c:	6a 3b                	push   $0x3b
  jmp alltraps
8010715e:	e9 94 f8 ff ff       	jmp    801069f7 <alltraps>

80107163 <vector60>:
.globl vector60
vector60:
  pushl $0
80107163:	6a 00                	push   $0x0
  pushl $60
80107165:	6a 3c                	push   $0x3c
  jmp alltraps
80107167:	e9 8b f8 ff ff       	jmp    801069f7 <alltraps>

8010716c <vector61>:
.globl vector61
vector61:
  pushl $0
8010716c:	6a 00                	push   $0x0
  pushl $61
8010716e:	6a 3d                	push   $0x3d
  jmp alltraps
80107170:	e9 82 f8 ff ff       	jmp    801069f7 <alltraps>

80107175 <vector62>:
.globl vector62
vector62:
  pushl $0
80107175:	6a 00                	push   $0x0
  pushl $62
80107177:	6a 3e                	push   $0x3e
  jmp alltraps
80107179:	e9 79 f8 ff ff       	jmp    801069f7 <alltraps>

8010717e <vector63>:
.globl vector63
vector63:
  pushl $0
8010717e:	6a 00                	push   $0x0
  pushl $63
80107180:	6a 3f                	push   $0x3f
  jmp alltraps
80107182:	e9 70 f8 ff ff       	jmp    801069f7 <alltraps>

80107187 <vector64>:
.globl vector64
vector64:
  pushl $0
80107187:	6a 00                	push   $0x0
  pushl $64
80107189:	6a 40                	push   $0x40
  jmp alltraps
8010718b:	e9 67 f8 ff ff       	jmp    801069f7 <alltraps>

80107190 <vector65>:
.globl vector65
vector65:
  pushl $0
80107190:	6a 00                	push   $0x0
  pushl $65
80107192:	6a 41                	push   $0x41
  jmp alltraps
80107194:	e9 5e f8 ff ff       	jmp    801069f7 <alltraps>

80107199 <vector66>:
.globl vector66
vector66:
  pushl $0
80107199:	6a 00                	push   $0x0
  pushl $66
8010719b:	6a 42                	push   $0x42
  jmp alltraps
8010719d:	e9 55 f8 ff ff       	jmp    801069f7 <alltraps>

801071a2 <vector67>:
.globl vector67
vector67:
  pushl $0
801071a2:	6a 00                	push   $0x0
  pushl $67
801071a4:	6a 43                	push   $0x43
  jmp alltraps
801071a6:	e9 4c f8 ff ff       	jmp    801069f7 <alltraps>

801071ab <vector68>:
.globl vector68
vector68:
  pushl $0
801071ab:	6a 00                	push   $0x0
  pushl $68
801071ad:	6a 44                	push   $0x44
  jmp alltraps
801071af:	e9 43 f8 ff ff       	jmp    801069f7 <alltraps>

801071b4 <vector69>:
.globl vector69
vector69:
  pushl $0
801071b4:	6a 00                	push   $0x0
  pushl $69
801071b6:	6a 45                	push   $0x45
  jmp alltraps
801071b8:	e9 3a f8 ff ff       	jmp    801069f7 <alltraps>

801071bd <vector70>:
.globl vector70
vector70:
  pushl $0
801071bd:	6a 00                	push   $0x0
  pushl $70
801071bf:	6a 46                	push   $0x46
  jmp alltraps
801071c1:	e9 31 f8 ff ff       	jmp    801069f7 <alltraps>

801071c6 <vector71>:
.globl vector71
vector71:
  pushl $0
801071c6:	6a 00                	push   $0x0
  pushl $71
801071c8:	6a 47                	push   $0x47
  jmp alltraps
801071ca:	e9 28 f8 ff ff       	jmp    801069f7 <alltraps>

801071cf <vector72>:
.globl vector72
vector72:
  pushl $0
801071cf:	6a 00                	push   $0x0
  pushl $72
801071d1:	6a 48                	push   $0x48
  jmp alltraps
801071d3:	e9 1f f8 ff ff       	jmp    801069f7 <alltraps>

801071d8 <vector73>:
.globl vector73
vector73:
  pushl $0
801071d8:	6a 00                	push   $0x0
  pushl $73
801071da:	6a 49                	push   $0x49
  jmp alltraps
801071dc:	e9 16 f8 ff ff       	jmp    801069f7 <alltraps>

801071e1 <vector74>:
.globl vector74
vector74:
  pushl $0
801071e1:	6a 00                	push   $0x0
  pushl $74
801071e3:	6a 4a                	push   $0x4a
  jmp alltraps
801071e5:	e9 0d f8 ff ff       	jmp    801069f7 <alltraps>

801071ea <vector75>:
.globl vector75
vector75:
  pushl $0
801071ea:	6a 00                	push   $0x0
  pushl $75
801071ec:	6a 4b                	push   $0x4b
  jmp alltraps
801071ee:	e9 04 f8 ff ff       	jmp    801069f7 <alltraps>

801071f3 <vector76>:
.globl vector76
vector76:
  pushl $0
801071f3:	6a 00                	push   $0x0
  pushl $76
801071f5:	6a 4c                	push   $0x4c
  jmp alltraps
801071f7:	e9 fb f7 ff ff       	jmp    801069f7 <alltraps>

801071fc <vector77>:
.globl vector77
vector77:
  pushl $0
801071fc:	6a 00                	push   $0x0
  pushl $77
801071fe:	6a 4d                	push   $0x4d
  jmp alltraps
80107200:	e9 f2 f7 ff ff       	jmp    801069f7 <alltraps>

80107205 <vector78>:
.globl vector78
vector78:
  pushl $0
80107205:	6a 00                	push   $0x0
  pushl $78
80107207:	6a 4e                	push   $0x4e
  jmp alltraps
80107209:	e9 e9 f7 ff ff       	jmp    801069f7 <alltraps>

8010720e <vector79>:
.globl vector79
vector79:
  pushl $0
8010720e:	6a 00                	push   $0x0
  pushl $79
80107210:	6a 4f                	push   $0x4f
  jmp alltraps
80107212:	e9 e0 f7 ff ff       	jmp    801069f7 <alltraps>

80107217 <vector80>:
.globl vector80
vector80:
  pushl $0
80107217:	6a 00                	push   $0x0
  pushl $80
80107219:	6a 50                	push   $0x50
  jmp alltraps
8010721b:	e9 d7 f7 ff ff       	jmp    801069f7 <alltraps>

80107220 <vector81>:
.globl vector81
vector81:
  pushl $0
80107220:	6a 00                	push   $0x0
  pushl $81
80107222:	6a 51                	push   $0x51
  jmp alltraps
80107224:	e9 ce f7 ff ff       	jmp    801069f7 <alltraps>

80107229 <vector82>:
.globl vector82
vector82:
  pushl $0
80107229:	6a 00                	push   $0x0
  pushl $82
8010722b:	6a 52                	push   $0x52
  jmp alltraps
8010722d:	e9 c5 f7 ff ff       	jmp    801069f7 <alltraps>

80107232 <vector83>:
.globl vector83
vector83:
  pushl $0
80107232:	6a 00                	push   $0x0
  pushl $83
80107234:	6a 53                	push   $0x53
  jmp alltraps
80107236:	e9 bc f7 ff ff       	jmp    801069f7 <alltraps>

8010723b <vector84>:
.globl vector84
vector84:
  pushl $0
8010723b:	6a 00                	push   $0x0
  pushl $84
8010723d:	6a 54                	push   $0x54
  jmp alltraps
8010723f:	e9 b3 f7 ff ff       	jmp    801069f7 <alltraps>

80107244 <vector85>:
.globl vector85
vector85:
  pushl $0
80107244:	6a 00                	push   $0x0
  pushl $85
80107246:	6a 55                	push   $0x55
  jmp alltraps
80107248:	e9 aa f7 ff ff       	jmp    801069f7 <alltraps>

8010724d <vector86>:
.globl vector86
vector86:
  pushl $0
8010724d:	6a 00                	push   $0x0
  pushl $86
8010724f:	6a 56                	push   $0x56
  jmp alltraps
80107251:	e9 a1 f7 ff ff       	jmp    801069f7 <alltraps>

80107256 <vector87>:
.globl vector87
vector87:
  pushl $0
80107256:	6a 00                	push   $0x0
  pushl $87
80107258:	6a 57                	push   $0x57
  jmp alltraps
8010725a:	e9 98 f7 ff ff       	jmp    801069f7 <alltraps>

8010725f <vector88>:
.globl vector88
vector88:
  pushl $0
8010725f:	6a 00                	push   $0x0
  pushl $88
80107261:	6a 58                	push   $0x58
  jmp alltraps
80107263:	e9 8f f7 ff ff       	jmp    801069f7 <alltraps>

80107268 <vector89>:
.globl vector89
vector89:
  pushl $0
80107268:	6a 00                	push   $0x0
  pushl $89
8010726a:	6a 59                	push   $0x59
  jmp alltraps
8010726c:	e9 86 f7 ff ff       	jmp    801069f7 <alltraps>

80107271 <vector90>:
.globl vector90
vector90:
  pushl $0
80107271:	6a 00                	push   $0x0
  pushl $90
80107273:	6a 5a                	push   $0x5a
  jmp alltraps
80107275:	e9 7d f7 ff ff       	jmp    801069f7 <alltraps>

8010727a <vector91>:
.globl vector91
vector91:
  pushl $0
8010727a:	6a 00                	push   $0x0
  pushl $91
8010727c:	6a 5b                	push   $0x5b
  jmp alltraps
8010727e:	e9 74 f7 ff ff       	jmp    801069f7 <alltraps>

80107283 <vector92>:
.globl vector92
vector92:
  pushl $0
80107283:	6a 00                	push   $0x0
  pushl $92
80107285:	6a 5c                	push   $0x5c
  jmp alltraps
80107287:	e9 6b f7 ff ff       	jmp    801069f7 <alltraps>

8010728c <vector93>:
.globl vector93
vector93:
  pushl $0
8010728c:	6a 00                	push   $0x0
  pushl $93
8010728e:	6a 5d                	push   $0x5d
  jmp alltraps
80107290:	e9 62 f7 ff ff       	jmp    801069f7 <alltraps>

80107295 <vector94>:
.globl vector94
vector94:
  pushl $0
80107295:	6a 00                	push   $0x0
  pushl $94
80107297:	6a 5e                	push   $0x5e
  jmp alltraps
80107299:	e9 59 f7 ff ff       	jmp    801069f7 <alltraps>

8010729e <vector95>:
.globl vector95
vector95:
  pushl $0
8010729e:	6a 00                	push   $0x0
  pushl $95
801072a0:	6a 5f                	push   $0x5f
  jmp alltraps
801072a2:	e9 50 f7 ff ff       	jmp    801069f7 <alltraps>

801072a7 <vector96>:
.globl vector96
vector96:
  pushl $0
801072a7:	6a 00                	push   $0x0
  pushl $96
801072a9:	6a 60                	push   $0x60
  jmp alltraps
801072ab:	e9 47 f7 ff ff       	jmp    801069f7 <alltraps>

801072b0 <vector97>:
.globl vector97
vector97:
  pushl $0
801072b0:	6a 00                	push   $0x0
  pushl $97
801072b2:	6a 61                	push   $0x61
  jmp alltraps
801072b4:	e9 3e f7 ff ff       	jmp    801069f7 <alltraps>

801072b9 <vector98>:
.globl vector98
vector98:
  pushl $0
801072b9:	6a 00                	push   $0x0
  pushl $98
801072bb:	6a 62                	push   $0x62
  jmp alltraps
801072bd:	e9 35 f7 ff ff       	jmp    801069f7 <alltraps>

801072c2 <vector99>:
.globl vector99
vector99:
  pushl $0
801072c2:	6a 00                	push   $0x0
  pushl $99
801072c4:	6a 63                	push   $0x63
  jmp alltraps
801072c6:	e9 2c f7 ff ff       	jmp    801069f7 <alltraps>

801072cb <vector100>:
.globl vector100
vector100:
  pushl $0
801072cb:	6a 00                	push   $0x0
  pushl $100
801072cd:	6a 64                	push   $0x64
  jmp alltraps
801072cf:	e9 23 f7 ff ff       	jmp    801069f7 <alltraps>

801072d4 <vector101>:
.globl vector101
vector101:
  pushl $0
801072d4:	6a 00                	push   $0x0
  pushl $101
801072d6:	6a 65                	push   $0x65
  jmp alltraps
801072d8:	e9 1a f7 ff ff       	jmp    801069f7 <alltraps>

801072dd <vector102>:
.globl vector102
vector102:
  pushl $0
801072dd:	6a 00                	push   $0x0
  pushl $102
801072df:	6a 66                	push   $0x66
  jmp alltraps
801072e1:	e9 11 f7 ff ff       	jmp    801069f7 <alltraps>

801072e6 <vector103>:
.globl vector103
vector103:
  pushl $0
801072e6:	6a 00                	push   $0x0
  pushl $103
801072e8:	6a 67                	push   $0x67
  jmp alltraps
801072ea:	e9 08 f7 ff ff       	jmp    801069f7 <alltraps>

801072ef <vector104>:
.globl vector104
vector104:
  pushl $0
801072ef:	6a 00                	push   $0x0
  pushl $104
801072f1:	6a 68                	push   $0x68
  jmp alltraps
801072f3:	e9 ff f6 ff ff       	jmp    801069f7 <alltraps>

801072f8 <vector105>:
.globl vector105
vector105:
  pushl $0
801072f8:	6a 00                	push   $0x0
  pushl $105
801072fa:	6a 69                	push   $0x69
  jmp alltraps
801072fc:	e9 f6 f6 ff ff       	jmp    801069f7 <alltraps>

80107301 <vector106>:
.globl vector106
vector106:
  pushl $0
80107301:	6a 00                	push   $0x0
  pushl $106
80107303:	6a 6a                	push   $0x6a
  jmp alltraps
80107305:	e9 ed f6 ff ff       	jmp    801069f7 <alltraps>

8010730a <vector107>:
.globl vector107
vector107:
  pushl $0
8010730a:	6a 00                	push   $0x0
  pushl $107
8010730c:	6a 6b                	push   $0x6b
  jmp alltraps
8010730e:	e9 e4 f6 ff ff       	jmp    801069f7 <alltraps>

80107313 <vector108>:
.globl vector108
vector108:
  pushl $0
80107313:	6a 00                	push   $0x0
  pushl $108
80107315:	6a 6c                	push   $0x6c
  jmp alltraps
80107317:	e9 db f6 ff ff       	jmp    801069f7 <alltraps>

8010731c <vector109>:
.globl vector109
vector109:
  pushl $0
8010731c:	6a 00                	push   $0x0
  pushl $109
8010731e:	6a 6d                	push   $0x6d
  jmp alltraps
80107320:	e9 d2 f6 ff ff       	jmp    801069f7 <alltraps>

80107325 <vector110>:
.globl vector110
vector110:
  pushl $0
80107325:	6a 00                	push   $0x0
  pushl $110
80107327:	6a 6e                	push   $0x6e
  jmp alltraps
80107329:	e9 c9 f6 ff ff       	jmp    801069f7 <alltraps>

8010732e <vector111>:
.globl vector111
vector111:
  pushl $0
8010732e:	6a 00                	push   $0x0
  pushl $111
80107330:	6a 6f                	push   $0x6f
  jmp alltraps
80107332:	e9 c0 f6 ff ff       	jmp    801069f7 <alltraps>

80107337 <vector112>:
.globl vector112
vector112:
  pushl $0
80107337:	6a 00                	push   $0x0
  pushl $112
80107339:	6a 70                	push   $0x70
  jmp alltraps
8010733b:	e9 b7 f6 ff ff       	jmp    801069f7 <alltraps>

80107340 <vector113>:
.globl vector113
vector113:
  pushl $0
80107340:	6a 00                	push   $0x0
  pushl $113
80107342:	6a 71                	push   $0x71
  jmp alltraps
80107344:	e9 ae f6 ff ff       	jmp    801069f7 <alltraps>

80107349 <vector114>:
.globl vector114
vector114:
  pushl $0
80107349:	6a 00                	push   $0x0
  pushl $114
8010734b:	6a 72                	push   $0x72
  jmp alltraps
8010734d:	e9 a5 f6 ff ff       	jmp    801069f7 <alltraps>

80107352 <vector115>:
.globl vector115
vector115:
  pushl $0
80107352:	6a 00                	push   $0x0
  pushl $115
80107354:	6a 73                	push   $0x73
  jmp alltraps
80107356:	e9 9c f6 ff ff       	jmp    801069f7 <alltraps>

8010735b <vector116>:
.globl vector116
vector116:
  pushl $0
8010735b:	6a 00                	push   $0x0
  pushl $116
8010735d:	6a 74                	push   $0x74
  jmp alltraps
8010735f:	e9 93 f6 ff ff       	jmp    801069f7 <alltraps>

80107364 <vector117>:
.globl vector117
vector117:
  pushl $0
80107364:	6a 00                	push   $0x0
  pushl $117
80107366:	6a 75                	push   $0x75
  jmp alltraps
80107368:	e9 8a f6 ff ff       	jmp    801069f7 <alltraps>

8010736d <vector118>:
.globl vector118
vector118:
  pushl $0
8010736d:	6a 00                	push   $0x0
  pushl $118
8010736f:	6a 76                	push   $0x76
  jmp alltraps
80107371:	e9 81 f6 ff ff       	jmp    801069f7 <alltraps>

80107376 <vector119>:
.globl vector119
vector119:
  pushl $0
80107376:	6a 00                	push   $0x0
  pushl $119
80107378:	6a 77                	push   $0x77
  jmp alltraps
8010737a:	e9 78 f6 ff ff       	jmp    801069f7 <alltraps>

8010737f <vector120>:
.globl vector120
vector120:
  pushl $0
8010737f:	6a 00                	push   $0x0
  pushl $120
80107381:	6a 78                	push   $0x78
  jmp alltraps
80107383:	e9 6f f6 ff ff       	jmp    801069f7 <alltraps>

80107388 <vector121>:
.globl vector121
vector121:
  pushl $0
80107388:	6a 00                	push   $0x0
  pushl $121
8010738a:	6a 79                	push   $0x79
  jmp alltraps
8010738c:	e9 66 f6 ff ff       	jmp    801069f7 <alltraps>

80107391 <vector122>:
.globl vector122
vector122:
  pushl $0
80107391:	6a 00                	push   $0x0
  pushl $122
80107393:	6a 7a                	push   $0x7a
  jmp alltraps
80107395:	e9 5d f6 ff ff       	jmp    801069f7 <alltraps>

8010739a <vector123>:
.globl vector123
vector123:
  pushl $0
8010739a:	6a 00                	push   $0x0
  pushl $123
8010739c:	6a 7b                	push   $0x7b
  jmp alltraps
8010739e:	e9 54 f6 ff ff       	jmp    801069f7 <alltraps>

801073a3 <vector124>:
.globl vector124
vector124:
  pushl $0
801073a3:	6a 00                	push   $0x0
  pushl $124
801073a5:	6a 7c                	push   $0x7c
  jmp alltraps
801073a7:	e9 4b f6 ff ff       	jmp    801069f7 <alltraps>

801073ac <vector125>:
.globl vector125
vector125:
  pushl $0
801073ac:	6a 00                	push   $0x0
  pushl $125
801073ae:	6a 7d                	push   $0x7d
  jmp alltraps
801073b0:	e9 42 f6 ff ff       	jmp    801069f7 <alltraps>

801073b5 <vector126>:
.globl vector126
vector126:
  pushl $0
801073b5:	6a 00                	push   $0x0
  pushl $126
801073b7:	6a 7e                	push   $0x7e
  jmp alltraps
801073b9:	e9 39 f6 ff ff       	jmp    801069f7 <alltraps>

801073be <vector127>:
.globl vector127
vector127:
  pushl $0
801073be:	6a 00                	push   $0x0
  pushl $127
801073c0:	6a 7f                	push   $0x7f
  jmp alltraps
801073c2:	e9 30 f6 ff ff       	jmp    801069f7 <alltraps>

801073c7 <vector128>:
.globl vector128
vector128:
  pushl $0
801073c7:	6a 00                	push   $0x0
  pushl $128
801073c9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801073ce:	e9 24 f6 ff ff       	jmp    801069f7 <alltraps>

801073d3 <vector129>:
.globl vector129
vector129:
  pushl $0
801073d3:	6a 00                	push   $0x0
  pushl $129
801073d5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801073da:	e9 18 f6 ff ff       	jmp    801069f7 <alltraps>

801073df <vector130>:
.globl vector130
vector130:
  pushl $0
801073df:	6a 00                	push   $0x0
  pushl $130
801073e1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801073e6:	e9 0c f6 ff ff       	jmp    801069f7 <alltraps>

801073eb <vector131>:
.globl vector131
vector131:
  pushl $0
801073eb:	6a 00                	push   $0x0
  pushl $131
801073ed:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801073f2:	e9 00 f6 ff ff       	jmp    801069f7 <alltraps>

801073f7 <vector132>:
.globl vector132
vector132:
  pushl $0
801073f7:	6a 00                	push   $0x0
  pushl $132
801073f9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801073fe:	e9 f4 f5 ff ff       	jmp    801069f7 <alltraps>

80107403 <vector133>:
.globl vector133
vector133:
  pushl $0
80107403:	6a 00                	push   $0x0
  pushl $133
80107405:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010740a:	e9 e8 f5 ff ff       	jmp    801069f7 <alltraps>

8010740f <vector134>:
.globl vector134
vector134:
  pushl $0
8010740f:	6a 00                	push   $0x0
  pushl $134
80107411:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80107416:	e9 dc f5 ff ff       	jmp    801069f7 <alltraps>

8010741b <vector135>:
.globl vector135
vector135:
  pushl $0
8010741b:	6a 00                	push   $0x0
  pushl $135
8010741d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80107422:	e9 d0 f5 ff ff       	jmp    801069f7 <alltraps>

80107427 <vector136>:
.globl vector136
vector136:
  pushl $0
80107427:	6a 00                	push   $0x0
  pushl $136
80107429:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010742e:	e9 c4 f5 ff ff       	jmp    801069f7 <alltraps>

80107433 <vector137>:
.globl vector137
vector137:
  pushl $0
80107433:	6a 00                	push   $0x0
  pushl $137
80107435:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010743a:	e9 b8 f5 ff ff       	jmp    801069f7 <alltraps>

8010743f <vector138>:
.globl vector138
vector138:
  pushl $0
8010743f:	6a 00                	push   $0x0
  pushl $138
80107441:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80107446:	e9 ac f5 ff ff       	jmp    801069f7 <alltraps>

8010744b <vector139>:
.globl vector139
vector139:
  pushl $0
8010744b:	6a 00                	push   $0x0
  pushl $139
8010744d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80107452:	e9 a0 f5 ff ff       	jmp    801069f7 <alltraps>

80107457 <vector140>:
.globl vector140
vector140:
  pushl $0
80107457:	6a 00                	push   $0x0
  pushl $140
80107459:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010745e:	e9 94 f5 ff ff       	jmp    801069f7 <alltraps>

80107463 <vector141>:
.globl vector141
vector141:
  pushl $0
80107463:	6a 00                	push   $0x0
  pushl $141
80107465:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010746a:	e9 88 f5 ff ff       	jmp    801069f7 <alltraps>

8010746f <vector142>:
.globl vector142
vector142:
  pushl $0
8010746f:	6a 00                	push   $0x0
  pushl $142
80107471:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80107476:	e9 7c f5 ff ff       	jmp    801069f7 <alltraps>

8010747b <vector143>:
.globl vector143
vector143:
  pushl $0
8010747b:	6a 00                	push   $0x0
  pushl $143
8010747d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80107482:	e9 70 f5 ff ff       	jmp    801069f7 <alltraps>

80107487 <vector144>:
.globl vector144
vector144:
  pushl $0
80107487:	6a 00                	push   $0x0
  pushl $144
80107489:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010748e:	e9 64 f5 ff ff       	jmp    801069f7 <alltraps>

80107493 <vector145>:
.globl vector145
vector145:
  pushl $0
80107493:	6a 00                	push   $0x0
  pushl $145
80107495:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010749a:	e9 58 f5 ff ff       	jmp    801069f7 <alltraps>

8010749f <vector146>:
.globl vector146
vector146:
  pushl $0
8010749f:	6a 00                	push   $0x0
  pushl $146
801074a1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801074a6:	e9 4c f5 ff ff       	jmp    801069f7 <alltraps>

801074ab <vector147>:
.globl vector147
vector147:
  pushl $0
801074ab:	6a 00                	push   $0x0
  pushl $147
801074ad:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801074b2:	e9 40 f5 ff ff       	jmp    801069f7 <alltraps>

801074b7 <vector148>:
.globl vector148
vector148:
  pushl $0
801074b7:	6a 00                	push   $0x0
  pushl $148
801074b9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801074be:	e9 34 f5 ff ff       	jmp    801069f7 <alltraps>

801074c3 <vector149>:
.globl vector149
vector149:
  pushl $0
801074c3:	6a 00                	push   $0x0
  pushl $149
801074c5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801074ca:	e9 28 f5 ff ff       	jmp    801069f7 <alltraps>

801074cf <vector150>:
.globl vector150
vector150:
  pushl $0
801074cf:	6a 00                	push   $0x0
  pushl $150
801074d1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801074d6:	e9 1c f5 ff ff       	jmp    801069f7 <alltraps>

801074db <vector151>:
.globl vector151
vector151:
  pushl $0
801074db:	6a 00                	push   $0x0
  pushl $151
801074dd:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801074e2:	e9 10 f5 ff ff       	jmp    801069f7 <alltraps>

801074e7 <vector152>:
.globl vector152
vector152:
  pushl $0
801074e7:	6a 00                	push   $0x0
  pushl $152
801074e9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801074ee:	e9 04 f5 ff ff       	jmp    801069f7 <alltraps>

801074f3 <vector153>:
.globl vector153
vector153:
  pushl $0
801074f3:	6a 00                	push   $0x0
  pushl $153
801074f5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801074fa:	e9 f8 f4 ff ff       	jmp    801069f7 <alltraps>

801074ff <vector154>:
.globl vector154
vector154:
  pushl $0
801074ff:	6a 00                	push   $0x0
  pushl $154
80107501:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80107506:	e9 ec f4 ff ff       	jmp    801069f7 <alltraps>

8010750b <vector155>:
.globl vector155
vector155:
  pushl $0
8010750b:	6a 00                	push   $0x0
  pushl $155
8010750d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80107512:	e9 e0 f4 ff ff       	jmp    801069f7 <alltraps>

80107517 <vector156>:
.globl vector156
vector156:
  pushl $0
80107517:	6a 00                	push   $0x0
  pushl $156
80107519:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010751e:	e9 d4 f4 ff ff       	jmp    801069f7 <alltraps>

80107523 <vector157>:
.globl vector157
vector157:
  pushl $0
80107523:	6a 00                	push   $0x0
  pushl $157
80107525:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010752a:	e9 c8 f4 ff ff       	jmp    801069f7 <alltraps>

8010752f <vector158>:
.globl vector158
vector158:
  pushl $0
8010752f:	6a 00                	push   $0x0
  pushl $158
80107531:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80107536:	e9 bc f4 ff ff       	jmp    801069f7 <alltraps>

8010753b <vector159>:
.globl vector159
vector159:
  pushl $0
8010753b:	6a 00                	push   $0x0
  pushl $159
8010753d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80107542:	e9 b0 f4 ff ff       	jmp    801069f7 <alltraps>

80107547 <vector160>:
.globl vector160
vector160:
  pushl $0
80107547:	6a 00                	push   $0x0
  pushl $160
80107549:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010754e:	e9 a4 f4 ff ff       	jmp    801069f7 <alltraps>

80107553 <vector161>:
.globl vector161
vector161:
  pushl $0
80107553:	6a 00                	push   $0x0
  pushl $161
80107555:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010755a:	e9 98 f4 ff ff       	jmp    801069f7 <alltraps>

8010755f <vector162>:
.globl vector162
vector162:
  pushl $0
8010755f:	6a 00                	push   $0x0
  pushl $162
80107561:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80107566:	e9 8c f4 ff ff       	jmp    801069f7 <alltraps>

8010756b <vector163>:
.globl vector163
vector163:
  pushl $0
8010756b:	6a 00                	push   $0x0
  pushl $163
8010756d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80107572:	e9 80 f4 ff ff       	jmp    801069f7 <alltraps>

80107577 <vector164>:
.globl vector164
vector164:
  pushl $0
80107577:	6a 00                	push   $0x0
  pushl $164
80107579:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010757e:	e9 74 f4 ff ff       	jmp    801069f7 <alltraps>

80107583 <vector165>:
.globl vector165
vector165:
  pushl $0
80107583:	6a 00                	push   $0x0
  pushl $165
80107585:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010758a:	e9 68 f4 ff ff       	jmp    801069f7 <alltraps>

8010758f <vector166>:
.globl vector166
vector166:
  pushl $0
8010758f:	6a 00                	push   $0x0
  pushl $166
80107591:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80107596:	e9 5c f4 ff ff       	jmp    801069f7 <alltraps>

8010759b <vector167>:
.globl vector167
vector167:
  pushl $0
8010759b:	6a 00                	push   $0x0
  pushl $167
8010759d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801075a2:	e9 50 f4 ff ff       	jmp    801069f7 <alltraps>

801075a7 <vector168>:
.globl vector168
vector168:
  pushl $0
801075a7:	6a 00                	push   $0x0
  pushl $168
801075a9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801075ae:	e9 44 f4 ff ff       	jmp    801069f7 <alltraps>

801075b3 <vector169>:
.globl vector169
vector169:
  pushl $0
801075b3:	6a 00                	push   $0x0
  pushl $169
801075b5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801075ba:	e9 38 f4 ff ff       	jmp    801069f7 <alltraps>

801075bf <vector170>:
.globl vector170
vector170:
  pushl $0
801075bf:	6a 00                	push   $0x0
  pushl $170
801075c1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801075c6:	e9 2c f4 ff ff       	jmp    801069f7 <alltraps>

801075cb <vector171>:
.globl vector171
vector171:
  pushl $0
801075cb:	6a 00                	push   $0x0
  pushl $171
801075cd:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801075d2:	e9 20 f4 ff ff       	jmp    801069f7 <alltraps>

801075d7 <vector172>:
.globl vector172
vector172:
  pushl $0
801075d7:	6a 00                	push   $0x0
  pushl $172
801075d9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801075de:	e9 14 f4 ff ff       	jmp    801069f7 <alltraps>

801075e3 <vector173>:
.globl vector173
vector173:
  pushl $0
801075e3:	6a 00                	push   $0x0
  pushl $173
801075e5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801075ea:	e9 08 f4 ff ff       	jmp    801069f7 <alltraps>

801075ef <vector174>:
.globl vector174
vector174:
  pushl $0
801075ef:	6a 00                	push   $0x0
  pushl $174
801075f1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801075f6:	e9 fc f3 ff ff       	jmp    801069f7 <alltraps>

801075fb <vector175>:
.globl vector175
vector175:
  pushl $0
801075fb:	6a 00                	push   $0x0
  pushl $175
801075fd:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80107602:	e9 f0 f3 ff ff       	jmp    801069f7 <alltraps>

80107607 <vector176>:
.globl vector176
vector176:
  pushl $0
80107607:	6a 00                	push   $0x0
  pushl $176
80107609:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010760e:	e9 e4 f3 ff ff       	jmp    801069f7 <alltraps>

80107613 <vector177>:
.globl vector177
vector177:
  pushl $0
80107613:	6a 00                	push   $0x0
  pushl $177
80107615:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010761a:	e9 d8 f3 ff ff       	jmp    801069f7 <alltraps>

8010761f <vector178>:
.globl vector178
vector178:
  pushl $0
8010761f:	6a 00                	push   $0x0
  pushl $178
80107621:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80107626:	e9 cc f3 ff ff       	jmp    801069f7 <alltraps>

8010762b <vector179>:
.globl vector179
vector179:
  pushl $0
8010762b:	6a 00                	push   $0x0
  pushl $179
8010762d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80107632:	e9 c0 f3 ff ff       	jmp    801069f7 <alltraps>

80107637 <vector180>:
.globl vector180
vector180:
  pushl $0
80107637:	6a 00                	push   $0x0
  pushl $180
80107639:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010763e:	e9 b4 f3 ff ff       	jmp    801069f7 <alltraps>

80107643 <vector181>:
.globl vector181
vector181:
  pushl $0
80107643:	6a 00                	push   $0x0
  pushl $181
80107645:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010764a:	e9 a8 f3 ff ff       	jmp    801069f7 <alltraps>

8010764f <vector182>:
.globl vector182
vector182:
  pushl $0
8010764f:	6a 00                	push   $0x0
  pushl $182
80107651:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80107656:	e9 9c f3 ff ff       	jmp    801069f7 <alltraps>

8010765b <vector183>:
.globl vector183
vector183:
  pushl $0
8010765b:	6a 00                	push   $0x0
  pushl $183
8010765d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80107662:	e9 90 f3 ff ff       	jmp    801069f7 <alltraps>

80107667 <vector184>:
.globl vector184
vector184:
  pushl $0
80107667:	6a 00                	push   $0x0
  pushl $184
80107669:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010766e:	e9 84 f3 ff ff       	jmp    801069f7 <alltraps>

80107673 <vector185>:
.globl vector185
vector185:
  pushl $0
80107673:	6a 00                	push   $0x0
  pushl $185
80107675:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010767a:	e9 78 f3 ff ff       	jmp    801069f7 <alltraps>

8010767f <vector186>:
.globl vector186
vector186:
  pushl $0
8010767f:	6a 00                	push   $0x0
  pushl $186
80107681:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80107686:	e9 6c f3 ff ff       	jmp    801069f7 <alltraps>

8010768b <vector187>:
.globl vector187
vector187:
  pushl $0
8010768b:	6a 00                	push   $0x0
  pushl $187
8010768d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80107692:	e9 60 f3 ff ff       	jmp    801069f7 <alltraps>

80107697 <vector188>:
.globl vector188
vector188:
  pushl $0
80107697:	6a 00                	push   $0x0
  pushl $188
80107699:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010769e:	e9 54 f3 ff ff       	jmp    801069f7 <alltraps>

801076a3 <vector189>:
.globl vector189
vector189:
  pushl $0
801076a3:	6a 00                	push   $0x0
  pushl $189
801076a5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801076aa:	e9 48 f3 ff ff       	jmp    801069f7 <alltraps>

801076af <vector190>:
.globl vector190
vector190:
  pushl $0
801076af:	6a 00                	push   $0x0
  pushl $190
801076b1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801076b6:	e9 3c f3 ff ff       	jmp    801069f7 <alltraps>

801076bb <vector191>:
.globl vector191
vector191:
  pushl $0
801076bb:	6a 00                	push   $0x0
  pushl $191
801076bd:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801076c2:	e9 30 f3 ff ff       	jmp    801069f7 <alltraps>

801076c7 <vector192>:
.globl vector192
vector192:
  pushl $0
801076c7:	6a 00                	push   $0x0
  pushl $192
801076c9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801076ce:	e9 24 f3 ff ff       	jmp    801069f7 <alltraps>

801076d3 <vector193>:
.globl vector193
vector193:
  pushl $0
801076d3:	6a 00                	push   $0x0
  pushl $193
801076d5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801076da:	e9 18 f3 ff ff       	jmp    801069f7 <alltraps>

801076df <vector194>:
.globl vector194
vector194:
  pushl $0
801076df:	6a 00                	push   $0x0
  pushl $194
801076e1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801076e6:	e9 0c f3 ff ff       	jmp    801069f7 <alltraps>

801076eb <vector195>:
.globl vector195
vector195:
  pushl $0
801076eb:	6a 00                	push   $0x0
  pushl $195
801076ed:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801076f2:	e9 00 f3 ff ff       	jmp    801069f7 <alltraps>

801076f7 <vector196>:
.globl vector196
vector196:
  pushl $0
801076f7:	6a 00                	push   $0x0
  pushl $196
801076f9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801076fe:	e9 f4 f2 ff ff       	jmp    801069f7 <alltraps>

80107703 <vector197>:
.globl vector197
vector197:
  pushl $0
80107703:	6a 00                	push   $0x0
  pushl $197
80107705:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010770a:	e9 e8 f2 ff ff       	jmp    801069f7 <alltraps>

8010770f <vector198>:
.globl vector198
vector198:
  pushl $0
8010770f:	6a 00                	push   $0x0
  pushl $198
80107711:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80107716:	e9 dc f2 ff ff       	jmp    801069f7 <alltraps>

8010771b <vector199>:
.globl vector199
vector199:
  pushl $0
8010771b:	6a 00                	push   $0x0
  pushl $199
8010771d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80107722:	e9 d0 f2 ff ff       	jmp    801069f7 <alltraps>

80107727 <vector200>:
.globl vector200
vector200:
  pushl $0
80107727:	6a 00                	push   $0x0
  pushl $200
80107729:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010772e:	e9 c4 f2 ff ff       	jmp    801069f7 <alltraps>

80107733 <vector201>:
.globl vector201
vector201:
  pushl $0
80107733:	6a 00                	push   $0x0
  pushl $201
80107735:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010773a:	e9 b8 f2 ff ff       	jmp    801069f7 <alltraps>

8010773f <vector202>:
.globl vector202
vector202:
  pushl $0
8010773f:	6a 00                	push   $0x0
  pushl $202
80107741:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80107746:	e9 ac f2 ff ff       	jmp    801069f7 <alltraps>

8010774b <vector203>:
.globl vector203
vector203:
  pushl $0
8010774b:	6a 00                	push   $0x0
  pushl $203
8010774d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80107752:	e9 a0 f2 ff ff       	jmp    801069f7 <alltraps>

80107757 <vector204>:
.globl vector204
vector204:
  pushl $0
80107757:	6a 00                	push   $0x0
  pushl $204
80107759:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010775e:	e9 94 f2 ff ff       	jmp    801069f7 <alltraps>

80107763 <vector205>:
.globl vector205
vector205:
  pushl $0
80107763:	6a 00                	push   $0x0
  pushl $205
80107765:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010776a:	e9 88 f2 ff ff       	jmp    801069f7 <alltraps>

8010776f <vector206>:
.globl vector206
vector206:
  pushl $0
8010776f:	6a 00                	push   $0x0
  pushl $206
80107771:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80107776:	e9 7c f2 ff ff       	jmp    801069f7 <alltraps>

8010777b <vector207>:
.globl vector207
vector207:
  pushl $0
8010777b:	6a 00                	push   $0x0
  pushl $207
8010777d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80107782:	e9 70 f2 ff ff       	jmp    801069f7 <alltraps>

80107787 <vector208>:
.globl vector208
vector208:
  pushl $0
80107787:	6a 00                	push   $0x0
  pushl $208
80107789:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010778e:	e9 64 f2 ff ff       	jmp    801069f7 <alltraps>

80107793 <vector209>:
.globl vector209
vector209:
  pushl $0
80107793:	6a 00                	push   $0x0
  pushl $209
80107795:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010779a:	e9 58 f2 ff ff       	jmp    801069f7 <alltraps>

8010779f <vector210>:
.globl vector210
vector210:
  pushl $0
8010779f:	6a 00                	push   $0x0
  pushl $210
801077a1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801077a6:	e9 4c f2 ff ff       	jmp    801069f7 <alltraps>

801077ab <vector211>:
.globl vector211
vector211:
  pushl $0
801077ab:	6a 00                	push   $0x0
  pushl $211
801077ad:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801077b2:	e9 40 f2 ff ff       	jmp    801069f7 <alltraps>

801077b7 <vector212>:
.globl vector212
vector212:
  pushl $0
801077b7:	6a 00                	push   $0x0
  pushl $212
801077b9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801077be:	e9 34 f2 ff ff       	jmp    801069f7 <alltraps>

801077c3 <vector213>:
.globl vector213
vector213:
  pushl $0
801077c3:	6a 00                	push   $0x0
  pushl $213
801077c5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801077ca:	e9 28 f2 ff ff       	jmp    801069f7 <alltraps>

801077cf <vector214>:
.globl vector214
vector214:
  pushl $0
801077cf:	6a 00                	push   $0x0
  pushl $214
801077d1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801077d6:	e9 1c f2 ff ff       	jmp    801069f7 <alltraps>

801077db <vector215>:
.globl vector215
vector215:
  pushl $0
801077db:	6a 00                	push   $0x0
  pushl $215
801077dd:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801077e2:	e9 10 f2 ff ff       	jmp    801069f7 <alltraps>

801077e7 <vector216>:
.globl vector216
vector216:
  pushl $0
801077e7:	6a 00                	push   $0x0
  pushl $216
801077e9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801077ee:	e9 04 f2 ff ff       	jmp    801069f7 <alltraps>

801077f3 <vector217>:
.globl vector217
vector217:
  pushl $0
801077f3:	6a 00                	push   $0x0
  pushl $217
801077f5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801077fa:	e9 f8 f1 ff ff       	jmp    801069f7 <alltraps>

801077ff <vector218>:
.globl vector218
vector218:
  pushl $0
801077ff:	6a 00                	push   $0x0
  pushl $218
80107801:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80107806:	e9 ec f1 ff ff       	jmp    801069f7 <alltraps>

8010780b <vector219>:
.globl vector219
vector219:
  pushl $0
8010780b:	6a 00                	push   $0x0
  pushl $219
8010780d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107812:	e9 e0 f1 ff ff       	jmp    801069f7 <alltraps>

80107817 <vector220>:
.globl vector220
vector220:
  pushl $0
80107817:	6a 00                	push   $0x0
  pushl $220
80107819:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010781e:	e9 d4 f1 ff ff       	jmp    801069f7 <alltraps>

80107823 <vector221>:
.globl vector221
vector221:
  pushl $0
80107823:	6a 00                	push   $0x0
  pushl $221
80107825:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010782a:	e9 c8 f1 ff ff       	jmp    801069f7 <alltraps>

8010782f <vector222>:
.globl vector222
vector222:
  pushl $0
8010782f:	6a 00                	push   $0x0
  pushl $222
80107831:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80107836:	e9 bc f1 ff ff       	jmp    801069f7 <alltraps>

8010783b <vector223>:
.globl vector223
vector223:
  pushl $0
8010783b:	6a 00                	push   $0x0
  pushl $223
8010783d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107842:	e9 b0 f1 ff ff       	jmp    801069f7 <alltraps>

80107847 <vector224>:
.globl vector224
vector224:
  pushl $0
80107847:	6a 00                	push   $0x0
  pushl $224
80107849:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010784e:	e9 a4 f1 ff ff       	jmp    801069f7 <alltraps>

80107853 <vector225>:
.globl vector225
vector225:
  pushl $0
80107853:	6a 00                	push   $0x0
  pushl $225
80107855:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010785a:	e9 98 f1 ff ff       	jmp    801069f7 <alltraps>

8010785f <vector226>:
.globl vector226
vector226:
  pushl $0
8010785f:	6a 00                	push   $0x0
  pushl $226
80107861:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80107866:	e9 8c f1 ff ff       	jmp    801069f7 <alltraps>

8010786b <vector227>:
.globl vector227
vector227:
  pushl $0
8010786b:	6a 00                	push   $0x0
  pushl $227
8010786d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107872:	e9 80 f1 ff ff       	jmp    801069f7 <alltraps>

80107877 <vector228>:
.globl vector228
vector228:
  pushl $0
80107877:	6a 00                	push   $0x0
  pushl $228
80107879:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010787e:	e9 74 f1 ff ff       	jmp    801069f7 <alltraps>

80107883 <vector229>:
.globl vector229
vector229:
  pushl $0
80107883:	6a 00                	push   $0x0
  pushl $229
80107885:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010788a:	e9 68 f1 ff ff       	jmp    801069f7 <alltraps>

8010788f <vector230>:
.globl vector230
vector230:
  pushl $0
8010788f:	6a 00                	push   $0x0
  pushl $230
80107891:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80107896:	e9 5c f1 ff ff       	jmp    801069f7 <alltraps>

8010789b <vector231>:
.globl vector231
vector231:
  pushl $0
8010789b:	6a 00                	push   $0x0
  pushl $231
8010789d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801078a2:	e9 50 f1 ff ff       	jmp    801069f7 <alltraps>

801078a7 <vector232>:
.globl vector232
vector232:
  pushl $0
801078a7:	6a 00                	push   $0x0
  pushl $232
801078a9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801078ae:	e9 44 f1 ff ff       	jmp    801069f7 <alltraps>

801078b3 <vector233>:
.globl vector233
vector233:
  pushl $0
801078b3:	6a 00                	push   $0x0
  pushl $233
801078b5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801078ba:	e9 38 f1 ff ff       	jmp    801069f7 <alltraps>

801078bf <vector234>:
.globl vector234
vector234:
  pushl $0
801078bf:	6a 00                	push   $0x0
  pushl $234
801078c1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801078c6:	e9 2c f1 ff ff       	jmp    801069f7 <alltraps>

801078cb <vector235>:
.globl vector235
vector235:
  pushl $0
801078cb:	6a 00                	push   $0x0
  pushl $235
801078cd:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801078d2:	e9 20 f1 ff ff       	jmp    801069f7 <alltraps>

801078d7 <vector236>:
.globl vector236
vector236:
  pushl $0
801078d7:	6a 00                	push   $0x0
  pushl $236
801078d9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801078de:	e9 14 f1 ff ff       	jmp    801069f7 <alltraps>

801078e3 <vector237>:
.globl vector237
vector237:
  pushl $0
801078e3:	6a 00                	push   $0x0
  pushl $237
801078e5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801078ea:	e9 08 f1 ff ff       	jmp    801069f7 <alltraps>

801078ef <vector238>:
.globl vector238
vector238:
  pushl $0
801078ef:	6a 00                	push   $0x0
  pushl $238
801078f1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801078f6:	e9 fc f0 ff ff       	jmp    801069f7 <alltraps>

801078fb <vector239>:
.globl vector239
vector239:
  pushl $0
801078fb:	6a 00                	push   $0x0
  pushl $239
801078fd:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107902:	e9 f0 f0 ff ff       	jmp    801069f7 <alltraps>

80107907 <vector240>:
.globl vector240
vector240:
  pushl $0
80107907:	6a 00                	push   $0x0
  pushl $240
80107909:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010790e:	e9 e4 f0 ff ff       	jmp    801069f7 <alltraps>

80107913 <vector241>:
.globl vector241
vector241:
  pushl $0
80107913:	6a 00                	push   $0x0
  pushl $241
80107915:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010791a:	e9 d8 f0 ff ff       	jmp    801069f7 <alltraps>

8010791f <vector242>:
.globl vector242
vector242:
  pushl $0
8010791f:	6a 00                	push   $0x0
  pushl $242
80107921:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80107926:	e9 cc f0 ff ff       	jmp    801069f7 <alltraps>

8010792b <vector243>:
.globl vector243
vector243:
  pushl $0
8010792b:	6a 00                	push   $0x0
  pushl $243
8010792d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107932:	e9 c0 f0 ff ff       	jmp    801069f7 <alltraps>

80107937 <vector244>:
.globl vector244
vector244:
  pushl $0
80107937:	6a 00                	push   $0x0
  pushl $244
80107939:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010793e:	e9 b4 f0 ff ff       	jmp    801069f7 <alltraps>

80107943 <vector245>:
.globl vector245
vector245:
  pushl $0
80107943:	6a 00                	push   $0x0
  pushl $245
80107945:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010794a:	e9 a8 f0 ff ff       	jmp    801069f7 <alltraps>

8010794f <vector246>:
.globl vector246
vector246:
  pushl $0
8010794f:	6a 00                	push   $0x0
  pushl $246
80107951:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107956:	e9 9c f0 ff ff       	jmp    801069f7 <alltraps>

8010795b <vector247>:
.globl vector247
vector247:
  pushl $0
8010795b:	6a 00                	push   $0x0
  pushl $247
8010795d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107962:	e9 90 f0 ff ff       	jmp    801069f7 <alltraps>

80107967 <vector248>:
.globl vector248
vector248:
  pushl $0
80107967:	6a 00                	push   $0x0
  pushl $248
80107969:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010796e:	e9 84 f0 ff ff       	jmp    801069f7 <alltraps>

80107973 <vector249>:
.globl vector249
vector249:
  pushl $0
80107973:	6a 00                	push   $0x0
  pushl $249
80107975:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010797a:	e9 78 f0 ff ff       	jmp    801069f7 <alltraps>

8010797f <vector250>:
.globl vector250
vector250:
  pushl $0
8010797f:	6a 00                	push   $0x0
  pushl $250
80107981:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107986:	e9 6c f0 ff ff       	jmp    801069f7 <alltraps>

8010798b <vector251>:
.globl vector251
vector251:
  pushl $0
8010798b:	6a 00                	push   $0x0
  pushl $251
8010798d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107992:	e9 60 f0 ff ff       	jmp    801069f7 <alltraps>

80107997 <vector252>:
.globl vector252
vector252:
  pushl $0
80107997:	6a 00                	push   $0x0
  pushl $252
80107999:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010799e:	e9 54 f0 ff ff       	jmp    801069f7 <alltraps>

801079a3 <vector253>:
.globl vector253
vector253:
  pushl $0
801079a3:	6a 00                	push   $0x0
  pushl $253
801079a5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801079aa:	e9 48 f0 ff ff       	jmp    801069f7 <alltraps>

801079af <vector254>:
.globl vector254
vector254:
  pushl $0
801079af:	6a 00                	push   $0x0
  pushl $254
801079b1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801079b6:	e9 3c f0 ff ff       	jmp    801069f7 <alltraps>

801079bb <vector255>:
.globl vector255
vector255:
  pushl $0
801079bb:	6a 00                	push   $0x0
  pushl $255
801079bd:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801079c2:	e9 30 f0 ff ff       	jmp    801069f7 <alltraps>
801079c7:	66 90                	xchg   %ax,%ax
801079c9:	66 90                	xchg   %ax,%ax
801079cb:	66 90                	xchg   %ax,%ax
801079cd:	66 90                	xchg   %ax,%ax
801079cf:	90                   	nop

801079d0 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801079d0:	55                   	push   %ebp
801079d1:	89 e5                	mov    %esp,%ebp
801079d3:	57                   	push   %edi
801079d4:	56                   	push   %esi
801079d5:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
801079d6:	89 d3                	mov    %edx,%ebx
{
801079d8:	89 d7                	mov    %edx,%edi
  pde = &pgdir[PDX(va)];
801079da:	c1 eb 16             	shr    $0x16,%ebx
801079dd:	8d 34 98             	lea    (%eax,%ebx,4),%esi
{
801079e0:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
801079e3:	8b 06                	mov    (%esi),%eax
801079e5:	a8 01                	test   $0x1,%al
801079e7:	74 27                	je     80107a10 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801079e9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801079ee:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
801079f4:	c1 ef 0a             	shr    $0xa,%edi
}
801079f7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
801079fa:	89 fa                	mov    %edi,%edx
801079fc:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107a02:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80107a05:	5b                   	pop    %ebx
80107a06:	5e                   	pop    %esi
80107a07:	5f                   	pop    %edi
80107a08:	5d                   	pop    %ebp
80107a09:	c3                   	ret    
80107a0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80107a10:	85 c9                	test   %ecx,%ecx
80107a12:	74 2c                	je     80107a40 <walkpgdir+0x70>
80107a14:	e8 a7 aa ff ff       	call   801024c0 <kalloc>
80107a19:	85 c0                	test   %eax,%eax
80107a1b:	89 c3                	mov    %eax,%ebx
80107a1d:	74 21                	je     80107a40 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
80107a1f:	83 ec 04             	sub    $0x4,%esp
80107a22:	68 00 10 00 00       	push   $0x1000
80107a27:	6a 00                	push   $0x0
80107a29:	50                   	push   %eax
80107a2a:	e8 f1 dc ff ff       	call   80105720 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80107a2f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107a35:	83 c4 10             	add    $0x10,%esp
80107a38:	83 c8 07             	or     $0x7,%eax
80107a3b:	89 06                	mov    %eax,(%esi)
80107a3d:	eb b5                	jmp    801079f4 <walkpgdir+0x24>
80107a3f:	90                   	nop
}
80107a40:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80107a43:	31 c0                	xor    %eax,%eax
}
80107a45:	5b                   	pop    %ebx
80107a46:	5e                   	pop    %esi
80107a47:	5f                   	pop    %edi
80107a48:	5d                   	pop    %ebp
80107a49:	c3                   	ret    
80107a4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107a50 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80107a50:	55                   	push   %ebp
80107a51:	89 e5                	mov    %esp,%ebp
80107a53:	57                   	push   %edi
80107a54:	56                   	push   %esi
80107a55:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80107a56:	89 d3                	mov    %edx,%ebx
80107a58:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80107a5e:	83 ec 1c             	sub    $0x1c,%esp
80107a61:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107a64:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80107a68:	8b 7d 08             	mov    0x8(%ebp),%edi
80107a6b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107a70:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80107a73:	8b 45 0c             	mov    0xc(%ebp),%eax
80107a76:	29 df                	sub    %ebx,%edi
80107a78:	83 c8 01             	or     $0x1,%eax
80107a7b:	89 45 dc             	mov    %eax,-0x24(%ebp)
80107a7e:	eb 15                	jmp    80107a95 <mappages+0x45>
    if(*pte & PTE_P)
80107a80:	f6 00 01             	testb  $0x1,(%eax)
80107a83:	75 45                	jne    80107aca <mappages+0x7a>
    *pte = pa | perm | PTE_P;
80107a85:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80107a88:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
    *pte = pa | perm | PTE_P;
80107a8b:	89 30                	mov    %esi,(%eax)
    if(a == last)
80107a8d:	74 31                	je     80107ac0 <mappages+0x70>
      break;
    a += PGSIZE;
80107a8f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107a95:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107a98:	b9 01 00 00 00       	mov    $0x1,%ecx
80107a9d:	89 da                	mov    %ebx,%edx
80107a9f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80107aa2:	e8 29 ff ff ff       	call   801079d0 <walkpgdir>
80107aa7:	85 c0                	test   %eax,%eax
80107aa9:	75 d5                	jne    80107a80 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80107aab:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107aae:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107ab3:	5b                   	pop    %ebx
80107ab4:	5e                   	pop    %esi
80107ab5:	5f                   	pop    %edi
80107ab6:	5d                   	pop    %ebp
80107ab7:	c3                   	ret    
80107ab8:	90                   	nop
80107ab9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107ac0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107ac3:	31 c0                	xor    %eax,%eax
}
80107ac5:	5b                   	pop    %ebx
80107ac6:	5e                   	pop    %esi
80107ac7:	5f                   	pop    %edi
80107ac8:	5d                   	pop    %ebp
80107ac9:	c3                   	ret    
      panic("remap");
80107aca:	83 ec 0c             	sub    $0xc,%esp
80107acd:	68 88 8f 10 80       	push   $0x80108f88
80107ad2:	e8 b9 88 ff ff       	call   80100390 <panic>
80107ad7:	89 f6                	mov    %esi,%esi
80107ad9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107ae0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107ae0:	55                   	push   %ebp
80107ae1:	89 e5                	mov    %esp,%ebp
80107ae3:	57                   	push   %edi
80107ae4:	56                   	push   %esi
80107ae5:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80107ae6:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107aec:	89 c7                	mov    %eax,%edi
  a = PGROUNDUP(newsz);
80107aee:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107af4:	83 ec 1c             	sub    $0x1c,%esp
80107af7:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80107afa:	39 d3                	cmp    %edx,%ebx
80107afc:	73 66                	jae    80107b64 <deallocuvm.part.0+0x84>
80107afe:	89 d6                	mov    %edx,%esi
80107b00:	eb 3d                	jmp    80107b3f <deallocuvm.part.0+0x5f>
80107b02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80107b08:	8b 10                	mov    (%eax),%edx
80107b0a:	f6 c2 01             	test   $0x1,%dl
80107b0d:	74 26                	je     80107b35 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80107b0f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80107b15:	74 58                	je     80107b6f <deallocuvm.part.0+0x8f>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80107b17:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80107b1a:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80107b20:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      kfree(v);
80107b23:	52                   	push   %edx
80107b24:	e8 e7 a7 ff ff       	call   80102310 <kfree>
      *pte = 0;
80107b29:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107b2c:	83 c4 10             	add    $0x10,%esp
80107b2f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80107b35:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107b3b:	39 f3                	cmp    %esi,%ebx
80107b3d:	73 25                	jae    80107b64 <deallocuvm.part.0+0x84>
    pte = walkpgdir(pgdir, (char*)a, 0);
80107b3f:	31 c9                	xor    %ecx,%ecx
80107b41:	89 da                	mov    %ebx,%edx
80107b43:	89 f8                	mov    %edi,%eax
80107b45:	e8 86 fe ff ff       	call   801079d0 <walkpgdir>
    if(!pte)
80107b4a:	85 c0                	test   %eax,%eax
80107b4c:	75 ba                	jne    80107b08 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80107b4e:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80107b54:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80107b5a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107b60:	39 f3                	cmp    %esi,%ebx
80107b62:	72 db                	jb     80107b3f <deallocuvm.part.0+0x5f>
    }
  }
  return newsz;
}
80107b64:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107b67:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107b6a:	5b                   	pop    %ebx
80107b6b:	5e                   	pop    %esi
80107b6c:	5f                   	pop    %edi
80107b6d:	5d                   	pop    %ebp
80107b6e:	c3                   	ret    
        panic("kfree");
80107b6f:	83 ec 0c             	sub    $0xc,%esp
80107b72:	68 66 85 10 80       	push   $0x80108566
80107b77:	e8 14 88 ff ff       	call   80100390 <panic>
80107b7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107b80 <seginit>:
{
80107b80:	55                   	push   %ebp
80107b81:	89 e5                	mov    %esp,%ebp
80107b83:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80107b86:	e8 f5 bc ff ff       	call   80103880 <cpuid>
80107b8b:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
  pd[0] = size-1;
80107b91:	ba 2f 00 00 00       	mov    $0x2f,%edx
80107b96:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80107b9a:	c7 80 18 48 11 80 ff 	movl   $0xffff,-0x7feeb7e8(%eax)
80107ba1:	ff 00 00 
80107ba4:	c7 80 1c 48 11 80 00 	movl   $0xcf9a00,-0x7feeb7e4(%eax)
80107bab:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107bae:	c7 80 20 48 11 80 ff 	movl   $0xffff,-0x7feeb7e0(%eax)
80107bb5:	ff 00 00 
80107bb8:	c7 80 24 48 11 80 00 	movl   $0xcf9200,-0x7feeb7dc(%eax)
80107bbf:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107bc2:	c7 80 28 48 11 80 ff 	movl   $0xffff,-0x7feeb7d8(%eax)
80107bc9:	ff 00 00 
80107bcc:	c7 80 2c 48 11 80 00 	movl   $0xcffa00,-0x7feeb7d4(%eax)
80107bd3:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107bd6:	c7 80 30 48 11 80 ff 	movl   $0xffff,-0x7feeb7d0(%eax)
80107bdd:	ff 00 00 
80107be0:	c7 80 34 48 11 80 00 	movl   $0xcff200,-0x7feeb7cc(%eax)
80107be7:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80107bea:	05 10 48 11 80       	add    $0x80114810,%eax
  pd[1] = (uint)p;
80107bef:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107bf3:	c1 e8 10             	shr    $0x10,%eax
80107bf6:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80107bfa:	8d 45 f2             	lea    -0xe(%ebp),%eax
80107bfd:	0f 01 10             	lgdtl  (%eax)
}
80107c00:	c9                   	leave  
80107c01:	c3                   	ret    
80107c02:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107c09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107c10 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107c10:	a1 c4 89 11 80       	mov    0x801189c4,%eax
{
80107c15:	55                   	push   %ebp
80107c16:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107c18:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107c1d:	0f 22 d8             	mov    %eax,%cr3
}
80107c20:	5d                   	pop    %ebp
80107c21:	c3                   	ret    
80107c22:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107c29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107c30 <switchuvm>:
{
80107c30:	55                   	push   %ebp
80107c31:	89 e5                	mov    %esp,%ebp
80107c33:	57                   	push   %edi
80107c34:	56                   	push   %esi
80107c35:	53                   	push   %ebx
80107c36:	83 ec 1c             	sub    $0x1c,%esp
80107c39:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
80107c3c:	85 db                	test   %ebx,%ebx
80107c3e:	0f 84 cb 00 00 00    	je     80107d0f <switchuvm+0xdf>
  if(p->kstack == 0)
80107c44:	8b 43 08             	mov    0x8(%ebx),%eax
80107c47:	85 c0                	test   %eax,%eax
80107c49:	0f 84 da 00 00 00    	je     80107d29 <switchuvm+0xf9>
  if(p->pgdir == 0)
80107c4f:	8b 43 04             	mov    0x4(%ebx),%eax
80107c52:	85 c0                	test   %eax,%eax
80107c54:	0f 84 c2 00 00 00    	je     80107d1c <switchuvm+0xec>
  pushcli();
80107c5a:	e8 e1 d8 ff ff       	call   80105540 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107c5f:	e8 9c bb ff ff       	call   80103800 <mycpu>
80107c64:	89 c6                	mov    %eax,%esi
80107c66:	e8 95 bb ff ff       	call   80103800 <mycpu>
80107c6b:	89 c7                	mov    %eax,%edi
80107c6d:	e8 8e bb ff ff       	call   80103800 <mycpu>
80107c72:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107c75:	83 c7 08             	add    $0x8,%edi
80107c78:	e8 83 bb ff ff       	call   80103800 <mycpu>
80107c7d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107c80:	83 c0 08             	add    $0x8,%eax
80107c83:	ba 67 00 00 00       	mov    $0x67,%edx
80107c88:	c1 e8 18             	shr    $0x18,%eax
80107c8b:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
80107c92:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
80107c99:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107c9f:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107ca4:	83 c1 08             	add    $0x8,%ecx
80107ca7:	c1 e9 10             	shr    $0x10,%ecx
80107caa:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
80107cb0:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107cb5:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107cbc:	be 10 00 00 00       	mov    $0x10,%esi
  mycpu()->gdt[SEG_TSS].s = 0;
80107cc1:	e8 3a bb ff ff       	call   80103800 <mycpu>
80107cc6:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107ccd:	e8 2e bb ff ff       	call   80103800 <mycpu>
80107cd2:	66 89 70 10          	mov    %si,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107cd6:	8b 73 08             	mov    0x8(%ebx),%esi
80107cd9:	e8 22 bb ff ff       	call   80103800 <mycpu>
80107cde:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107ce4:	89 70 0c             	mov    %esi,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107ce7:	e8 14 bb ff ff       	call   80103800 <mycpu>
80107cec:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80107cf0:	b8 28 00 00 00       	mov    $0x28,%eax
80107cf5:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80107cf8:	8b 43 04             	mov    0x4(%ebx),%eax
80107cfb:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107d00:	0f 22 d8             	mov    %eax,%cr3
}
80107d03:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107d06:	5b                   	pop    %ebx
80107d07:	5e                   	pop    %esi
80107d08:	5f                   	pop    %edi
80107d09:	5d                   	pop    %ebp
  popcli();
80107d0a:	e9 71 d8 ff ff       	jmp    80105580 <popcli>
    panic("switchuvm: no process");
80107d0f:	83 ec 0c             	sub    $0xc,%esp
80107d12:	68 8e 8f 10 80       	push   $0x80108f8e
80107d17:	e8 74 86 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
80107d1c:	83 ec 0c             	sub    $0xc,%esp
80107d1f:	68 b9 8f 10 80       	push   $0x80108fb9
80107d24:	e8 67 86 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
80107d29:	83 ec 0c             	sub    $0xc,%esp
80107d2c:	68 a4 8f 10 80       	push   $0x80108fa4
80107d31:	e8 5a 86 ff ff       	call   80100390 <panic>
80107d36:	8d 76 00             	lea    0x0(%esi),%esi
80107d39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107d40 <inituvm>:
{
80107d40:	55                   	push   %ebp
80107d41:	89 e5                	mov    %esp,%ebp
80107d43:	57                   	push   %edi
80107d44:	56                   	push   %esi
80107d45:	53                   	push   %ebx
80107d46:	83 ec 1c             	sub    $0x1c,%esp
80107d49:	8b 75 10             	mov    0x10(%ebp),%esi
80107d4c:	8b 45 08             	mov    0x8(%ebp),%eax
80107d4f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(sz >= PGSIZE)
80107d52:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
80107d58:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80107d5b:	77 49                	ja     80107da6 <inituvm+0x66>
  mem = kalloc();
80107d5d:	e8 5e a7 ff ff       	call   801024c0 <kalloc>
  memset(mem, 0, PGSIZE);
80107d62:	83 ec 04             	sub    $0x4,%esp
  mem = kalloc();
80107d65:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80107d67:	68 00 10 00 00       	push   $0x1000
80107d6c:	6a 00                	push   $0x0
80107d6e:	50                   	push   %eax
80107d6f:	e8 ac d9 ff ff       	call   80105720 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107d74:	58                   	pop    %eax
80107d75:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107d7b:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107d80:	5a                   	pop    %edx
80107d81:	6a 06                	push   $0x6
80107d83:	50                   	push   %eax
80107d84:	31 d2                	xor    %edx,%edx
80107d86:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107d89:	e8 c2 fc ff ff       	call   80107a50 <mappages>
  memmove(mem, init, sz);
80107d8e:	89 75 10             	mov    %esi,0x10(%ebp)
80107d91:	89 7d 0c             	mov    %edi,0xc(%ebp)
80107d94:	83 c4 10             	add    $0x10,%esp
80107d97:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80107d9a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107d9d:	5b                   	pop    %ebx
80107d9e:	5e                   	pop    %esi
80107d9f:	5f                   	pop    %edi
80107da0:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107da1:	e9 2a da ff ff       	jmp    801057d0 <memmove>
    panic("inituvm: more than a page");
80107da6:	83 ec 0c             	sub    $0xc,%esp
80107da9:	68 cd 8f 10 80       	push   $0x80108fcd
80107dae:	e8 dd 85 ff ff       	call   80100390 <panic>
80107db3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107db9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107dc0 <loaduvm>:
{
80107dc0:	55                   	push   %ebp
80107dc1:	89 e5                	mov    %esp,%ebp
80107dc3:	57                   	push   %edi
80107dc4:	56                   	push   %esi
80107dc5:	53                   	push   %ebx
80107dc6:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
80107dc9:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80107dd0:	0f 85 91 00 00 00    	jne    80107e67 <loaduvm+0xa7>
  for(i = 0; i < sz; i += PGSIZE){
80107dd6:	8b 75 18             	mov    0x18(%ebp),%esi
80107dd9:	31 db                	xor    %ebx,%ebx
80107ddb:	85 f6                	test   %esi,%esi
80107ddd:	75 1a                	jne    80107df9 <loaduvm+0x39>
80107ddf:	eb 6f                	jmp    80107e50 <loaduvm+0x90>
80107de1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107de8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107dee:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80107df4:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80107df7:	76 57                	jbe    80107e50 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107df9:	8b 55 0c             	mov    0xc(%ebp),%edx
80107dfc:	8b 45 08             	mov    0x8(%ebp),%eax
80107dff:	31 c9                	xor    %ecx,%ecx
80107e01:	01 da                	add    %ebx,%edx
80107e03:	e8 c8 fb ff ff       	call   801079d0 <walkpgdir>
80107e08:	85 c0                	test   %eax,%eax
80107e0a:	74 4e                	je     80107e5a <loaduvm+0x9a>
    pa = PTE_ADDR(*pte);
80107e0c:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107e0e:	8b 4d 14             	mov    0x14(%ebp),%ecx
    if(sz - i < PGSIZE)
80107e11:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107e16:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80107e1b:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80107e21:	0f 46 fe             	cmovbe %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107e24:	01 d9                	add    %ebx,%ecx
80107e26:	05 00 00 00 80       	add    $0x80000000,%eax
80107e2b:	57                   	push   %edi
80107e2c:	51                   	push   %ecx
80107e2d:	50                   	push   %eax
80107e2e:	ff 75 10             	pushl  0x10(%ebp)
80107e31:	e8 2a 9b ff ff       	call   80101960 <readi>
80107e36:	83 c4 10             	add    $0x10,%esp
80107e39:	39 f8                	cmp    %edi,%eax
80107e3b:	74 ab                	je     80107de8 <loaduvm+0x28>
}
80107e3d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107e40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107e45:	5b                   	pop    %ebx
80107e46:	5e                   	pop    %esi
80107e47:	5f                   	pop    %edi
80107e48:	5d                   	pop    %ebp
80107e49:	c3                   	ret    
80107e4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107e50:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107e53:	31 c0                	xor    %eax,%eax
}
80107e55:	5b                   	pop    %ebx
80107e56:	5e                   	pop    %esi
80107e57:	5f                   	pop    %edi
80107e58:	5d                   	pop    %ebp
80107e59:	c3                   	ret    
      panic("loaduvm: address should exist");
80107e5a:	83 ec 0c             	sub    $0xc,%esp
80107e5d:	68 e7 8f 10 80       	push   $0x80108fe7
80107e62:	e8 29 85 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80107e67:	83 ec 0c             	sub    $0xc,%esp
80107e6a:	68 88 90 10 80       	push   $0x80109088
80107e6f:	e8 1c 85 ff ff       	call   80100390 <panic>
80107e74:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107e7a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107e80 <allocuvm>:
{
80107e80:	55                   	push   %ebp
80107e81:	89 e5                	mov    %esp,%ebp
80107e83:	57                   	push   %edi
80107e84:	56                   	push   %esi
80107e85:	53                   	push   %ebx
80107e86:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80107e89:	8b 7d 10             	mov    0x10(%ebp),%edi
80107e8c:	85 ff                	test   %edi,%edi
80107e8e:	0f 88 8e 00 00 00    	js     80107f22 <allocuvm+0xa2>
  if(newsz < oldsz)
80107e94:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80107e97:	0f 82 93 00 00 00    	jb     80107f30 <allocuvm+0xb0>
  a = PGROUNDUP(oldsz);
80107e9d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107ea0:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80107ea6:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
80107eac:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80107eaf:	0f 86 7e 00 00 00    	jbe    80107f33 <allocuvm+0xb3>
80107eb5:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80107eb8:	8b 7d 08             	mov    0x8(%ebp),%edi
80107ebb:	eb 42                	jmp    80107eff <allocuvm+0x7f>
80107ebd:	8d 76 00             	lea    0x0(%esi),%esi
    memset(mem, 0, PGSIZE);
80107ec0:	83 ec 04             	sub    $0x4,%esp
80107ec3:	68 00 10 00 00       	push   $0x1000
80107ec8:	6a 00                	push   $0x0
80107eca:	50                   	push   %eax
80107ecb:	e8 50 d8 ff ff       	call   80105720 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107ed0:	58                   	pop    %eax
80107ed1:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80107ed7:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107edc:	5a                   	pop    %edx
80107edd:	6a 06                	push   $0x6
80107edf:	50                   	push   %eax
80107ee0:	89 da                	mov    %ebx,%edx
80107ee2:	89 f8                	mov    %edi,%eax
80107ee4:	e8 67 fb ff ff       	call   80107a50 <mappages>
80107ee9:	83 c4 10             	add    $0x10,%esp
80107eec:	85 c0                	test   %eax,%eax
80107eee:	78 50                	js     80107f40 <allocuvm+0xc0>
  for(; a < newsz; a += PGSIZE){
80107ef0:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107ef6:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80107ef9:	0f 86 81 00 00 00    	jbe    80107f80 <allocuvm+0x100>
    mem = kalloc();
80107eff:	e8 bc a5 ff ff       	call   801024c0 <kalloc>
    if(mem == 0){
80107f04:	85 c0                	test   %eax,%eax
    mem = kalloc();
80107f06:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80107f08:	75 b6                	jne    80107ec0 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80107f0a:	83 ec 0c             	sub    $0xc,%esp
80107f0d:	68 05 90 10 80       	push   $0x80109005
80107f12:	e8 49 87 ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
80107f17:	83 c4 10             	add    $0x10,%esp
80107f1a:	8b 45 0c             	mov    0xc(%ebp),%eax
80107f1d:	39 45 10             	cmp    %eax,0x10(%ebp)
80107f20:	77 6e                	ja     80107f90 <allocuvm+0x110>
}
80107f22:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80107f25:	31 ff                	xor    %edi,%edi
}
80107f27:	89 f8                	mov    %edi,%eax
80107f29:	5b                   	pop    %ebx
80107f2a:	5e                   	pop    %esi
80107f2b:	5f                   	pop    %edi
80107f2c:	5d                   	pop    %ebp
80107f2d:	c3                   	ret    
80107f2e:	66 90                	xchg   %ax,%ax
    return oldsz;
80107f30:	8b 7d 0c             	mov    0xc(%ebp),%edi
}
80107f33:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107f36:	89 f8                	mov    %edi,%eax
80107f38:	5b                   	pop    %ebx
80107f39:	5e                   	pop    %esi
80107f3a:	5f                   	pop    %edi
80107f3b:	5d                   	pop    %ebp
80107f3c:	c3                   	ret    
80107f3d:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107f40:	83 ec 0c             	sub    $0xc,%esp
80107f43:	68 1d 90 10 80       	push   $0x8010901d
80107f48:	e8 13 87 ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
80107f4d:	83 c4 10             	add    $0x10,%esp
80107f50:	8b 45 0c             	mov    0xc(%ebp),%eax
80107f53:	39 45 10             	cmp    %eax,0x10(%ebp)
80107f56:	76 0d                	jbe    80107f65 <allocuvm+0xe5>
80107f58:	89 c1                	mov    %eax,%ecx
80107f5a:	8b 55 10             	mov    0x10(%ebp),%edx
80107f5d:	8b 45 08             	mov    0x8(%ebp),%eax
80107f60:	e8 7b fb ff ff       	call   80107ae0 <deallocuvm.part.0>
      kfree(mem);
80107f65:	83 ec 0c             	sub    $0xc,%esp
      return 0;
80107f68:	31 ff                	xor    %edi,%edi
      kfree(mem);
80107f6a:	56                   	push   %esi
80107f6b:	e8 a0 a3 ff ff       	call   80102310 <kfree>
      return 0;
80107f70:	83 c4 10             	add    $0x10,%esp
}
80107f73:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107f76:	89 f8                	mov    %edi,%eax
80107f78:	5b                   	pop    %ebx
80107f79:	5e                   	pop    %esi
80107f7a:	5f                   	pop    %edi
80107f7b:	5d                   	pop    %ebp
80107f7c:	c3                   	ret    
80107f7d:	8d 76 00             	lea    0x0(%esi),%esi
80107f80:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80107f83:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107f86:	5b                   	pop    %ebx
80107f87:	89 f8                	mov    %edi,%eax
80107f89:	5e                   	pop    %esi
80107f8a:	5f                   	pop    %edi
80107f8b:	5d                   	pop    %ebp
80107f8c:	c3                   	ret    
80107f8d:	8d 76 00             	lea    0x0(%esi),%esi
80107f90:	89 c1                	mov    %eax,%ecx
80107f92:	8b 55 10             	mov    0x10(%ebp),%edx
80107f95:	8b 45 08             	mov    0x8(%ebp),%eax
      return 0;
80107f98:	31 ff                	xor    %edi,%edi
80107f9a:	e8 41 fb ff ff       	call   80107ae0 <deallocuvm.part.0>
80107f9f:	eb 92                	jmp    80107f33 <allocuvm+0xb3>
80107fa1:	eb 0d                	jmp    80107fb0 <deallocuvm>
80107fa3:	90                   	nop
80107fa4:	90                   	nop
80107fa5:	90                   	nop
80107fa6:	90                   	nop
80107fa7:	90                   	nop
80107fa8:	90                   	nop
80107fa9:	90                   	nop
80107faa:	90                   	nop
80107fab:	90                   	nop
80107fac:	90                   	nop
80107fad:	90                   	nop
80107fae:	90                   	nop
80107faf:	90                   	nop

80107fb0 <deallocuvm>:
{
80107fb0:	55                   	push   %ebp
80107fb1:	89 e5                	mov    %esp,%ebp
80107fb3:	8b 55 0c             	mov    0xc(%ebp),%edx
80107fb6:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107fb9:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80107fbc:	39 d1                	cmp    %edx,%ecx
80107fbe:	73 10                	jae    80107fd0 <deallocuvm+0x20>
}
80107fc0:	5d                   	pop    %ebp
80107fc1:	e9 1a fb ff ff       	jmp    80107ae0 <deallocuvm.part.0>
80107fc6:	8d 76 00             	lea    0x0(%esi),%esi
80107fc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80107fd0:	89 d0                	mov    %edx,%eax
80107fd2:	5d                   	pop    %ebp
80107fd3:	c3                   	ret    
80107fd4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107fda:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107fe0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107fe0:	55                   	push   %ebp
80107fe1:	89 e5                	mov    %esp,%ebp
80107fe3:	57                   	push   %edi
80107fe4:	56                   	push   %esi
80107fe5:	53                   	push   %ebx
80107fe6:	83 ec 0c             	sub    $0xc,%esp
80107fe9:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80107fec:	85 f6                	test   %esi,%esi
80107fee:	74 59                	je     80108049 <freevm+0x69>
80107ff0:	31 c9                	xor    %ecx,%ecx
80107ff2:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107ff7:	89 f0                	mov    %esi,%eax
80107ff9:	e8 e2 fa ff ff       	call   80107ae0 <deallocuvm.part.0>
80107ffe:	89 f3                	mov    %esi,%ebx
80108000:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80108006:	eb 0f                	jmp    80108017 <freevm+0x37>
80108008:	90                   	nop
80108009:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108010:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80108013:	39 fb                	cmp    %edi,%ebx
80108015:	74 23                	je     8010803a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80108017:	8b 03                	mov    (%ebx),%eax
80108019:	a8 01                	test   $0x1,%al
8010801b:	74 f3                	je     80108010 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010801d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80108022:	83 ec 0c             	sub    $0xc,%esp
80108025:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80108028:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010802d:	50                   	push   %eax
8010802e:	e8 dd a2 ff ff       	call   80102310 <kfree>
80108033:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80108036:	39 fb                	cmp    %edi,%ebx
80108038:	75 dd                	jne    80108017 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010803a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010803d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108040:	5b                   	pop    %ebx
80108041:	5e                   	pop    %esi
80108042:	5f                   	pop    %edi
80108043:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80108044:	e9 c7 a2 ff ff       	jmp    80102310 <kfree>
    panic("freevm: no pgdir");
80108049:	83 ec 0c             	sub    $0xc,%esp
8010804c:	68 39 90 10 80       	push   $0x80109039
80108051:	e8 3a 83 ff ff       	call   80100390 <panic>
80108056:	8d 76 00             	lea    0x0(%esi),%esi
80108059:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80108060 <setupkvm>:
{
80108060:	55                   	push   %ebp
80108061:	89 e5                	mov    %esp,%ebp
80108063:	56                   	push   %esi
80108064:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80108065:	e8 56 a4 ff ff       	call   801024c0 <kalloc>
8010806a:	85 c0                	test   %eax,%eax
8010806c:	89 c6                	mov    %eax,%esi
8010806e:	74 42                	je     801080b2 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80108070:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80108073:	bb 40 c4 10 80       	mov    $0x8010c440,%ebx
  memset(pgdir, 0, PGSIZE);
80108078:	68 00 10 00 00       	push   $0x1000
8010807d:	6a 00                	push   $0x0
8010807f:	50                   	push   %eax
80108080:	e8 9b d6 ff ff       	call   80105720 <memset>
80108085:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80108088:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010808b:	8b 4b 08             	mov    0x8(%ebx),%ecx
8010808e:	83 ec 08             	sub    $0x8,%esp
80108091:	8b 13                	mov    (%ebx),%edx
80108093:	ff 73 0c             	pushl  0xc(%ebx)
80108096:	50                   	push   %eax
80108097:	29 c1                	sub    %eax,%ecx
80108099:	89 f0                	mov    %esi,%eax
8010809b:	e8 b0 f9 ff ff       	call   80107a50 <mappages>
801080a0:	83 c4 10             	add    $0x10,%esp
801080a3:	85 c0                	test   %eax,%eax
801080a5:	78 19                	js     801080c0 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801080a7:	83 c3 10             	add    $0x10,%ebx
801080aa:	81 fb 80 c4 10 80    	cmp    $0x8010c480,%ebx
801080b0:	75 d6                	jne    80108088 <setupkvm+0x28>
}
801080b2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801080b5:	89 f0                	mov    %esi,%eax
801080b7:	5b                   	pop    %ebx
801080b8:	5e                   	pop    %esi
801080b9:	5d                   	pop    %ebp
801080ba:	c3                   	ret    
801080bb:	90                   	nop
801080bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
801080c0:	83 ec 0c             	sub    $0xc,%esp
801080c3:	56                   	push   %esi
      return 0;
801080c4:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
801080c6:	e8 15 ff ff ff       	call   80107fe0 <freevm>
      return 0;
801080cb:	83 c4 10             	add    $0x10,%esp
}
801080ce:	8d 65 f8             	lea    -0x8(%ebp),%esp
801080d1:	89 f0                	mov    %esi,%eax
801080d3:	5b                   	pop    %ebx
801080d4:	5e                   	pop    %esi
801080d5:	5d                   	pop    %ebp
801080d6:	c3                   	ret    
801080d7:	89 f6                	mov    %esi,%esi
801080d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801080e0 <kvmalloc>:
{
801080e0:	55                   	push   %ebp
801080e1:	89 e5                	mov    %esp,%ebp
801080e3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801080e6:	e8 75 ff ff ff       	call   80108060 <setupkvm>
801080eb:	a3 c4 89 11 80       	mov    %eax,0x801189c4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801080f0:	05 00 00 00 80       	add    $0x80000000,%eax
801080f5:	0f 22 d8             	mov    %eax,%cr3
}
801080f8:	c9                   	leave  
801080f9:	c3                   	ret    
801080fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80108100 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80108100:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108101:	31 c9                	xor    %ecx,%ecx
{
80108103:	89 e5                	mov    %esp,%ebp
80108105:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80108108:	8b 55 0c             	mov    0xc(%ebp),%edx
8010810b:	8b 45 08             	mov    0x8(%ebp),%eax
8010810e:	e8 bd f8 ff ff       	call   801079d0 <walkpgdir>
  if(pte == 0)
80108113:	85 c0                	test   %eax,%eax
80108115:	74 05                	je     8010811c <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80108117:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010811a:	c9                   	leave  
8010811b:	c3                   	ret    
    panic("clearpteu");
8010811c:	83 ec 0c             	sub    $0xc,%esp
8010811f:	68 4a 90 10 80       	push   $0x8010904a
80108124:	e8 67 82 ff ff       	call   80100390 <panic>
80108129:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80108130 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80108130:	55                   	push   %ebp
80108131:	89 e5                	mov    %esp,%ebp
80108133:	57                   	push   %edi
80108134:	56                   	push   %esi
80108135:	53                   	push   %ebx
80108136:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80108139:	e8 22 ff ff ff       	call   80108060 <setupkvm>
8010813e:	85 c0                	test   %eax,%eax
80108140:	89 45 e0             	mov    %eax,-0x20(%ebp)
80108143:	0f 84 9f 00 00 00    	je     801081e8 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80108149:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010814c:	85 c9                	test   %ecx,%ecx
8010814e:	0f 84 94 00 00 00    	je     801081e8 <copyuvm+0xb8>
80108154:	31 ff                	xor    %edi,%edi
80108156:	eb 4a                	jmp    801081a2 <copyuvm+0x72>
80108158:	90                   	nop
80108159:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80108160:	83 ec 04             	sub    $0x4,%esp
80108163:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
80108169:	68 00 10 00 00       	push   $0x1000
8010816e:	53                   	push   %ebx
8010816f:	50                   	push   %eax
80108170:	e8 5b d6 ff ff       	call   801057d0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80108175:	58                   	pop    %eax
80108176:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
8010817c:	b9 00 10 00 00       	mov    $0x1000,%ecx
80108181:	5a                   	pop    %edx
80108182:	ff 75 e4             	pushl  -0x1c(%ebp)
80108185:	50                   	push   %eax
80108186:	89 fa                	mov    %edi,%edx
80108188:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010818b:	e8 c0 f8 ff ff       	call   80107a50 <mappages>
80108190:	83 c4 10             	add    $0x10,%esp
80108193:	85 c0                	test   %eax,%eax
80108195:	78 61                	js     801081f8 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80108197:	81 c7 00 10 00 00    	add    $0x1000,%edi
8010819d:	39 7d 0c             	cmp    %edi,0xc(%ebp)
801081a0:	76 46                	jbe    801081e8 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801081a2:	8b 45 08             	mov    0x8(%ebp),%eax
801081a5:	31 c9                	xor    %ecx,%ecx
801081a7:	89 fa                	mov    %edi,%edx
801081a9:	e8 22 f8 ff ff       	call   801079d0 <walkpgdir>
801081ae:	85 c0                	test   %eax,%eax
801081b0:	74 61                	je     80108213 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
801081b2:	8b 00                	mov    (%eax),%eax
801081b4:	a8 01                	test   $0x1,%al
801081b6:	74 4e                	je     80108206 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
801081b8:	89 c3                	mov    %eax,%ebx
    flags = PTE_FLAGS(*pte);
801081ba:	25 ff 0f 00 00       	and    $0xfff,%eax
    pa = PTE_ADDR(*pte);
801081bf:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    flags = PTE_FLAGS(*pte);
801081c5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
801081c8:	e8 f3 a2 ff ff       	call   801024c0 <kalloc>
801081cd:	85 c0                	test   %eax,%eax
801081cf:	89 c6                	mov    %eax,%esi
801081d1:	75 8d                	jne    80108160 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
801081d3:	83 ec 0c             	sub    $0xc,%esp
801081d6:	ff 75 e0             	pushl  -0x20(%ebp)
801081d9:	e8 02 fe ff ff       	call   80107fe0 <freevm>
  return 0;
801081de:	83 c4 10             	add    $0x10,%esp
801081e1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
801081e8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801081eb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801081ee:	5b                   	pop    %ebx
801081ef:	5e                   	pop    %esi
801081f0:	5f                   	pop    %edi
801081f1:	5d                   	pop    %ebp
801081f2:	c3                   	ret    
801081f3:	90                   	nop
801081f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
801081f8:	83 ec 0c             	sub    $0xc,%esp
801081fb:	56                   	push   %esi
801081fc:	e8 0f a1 ff ff       	call   80102310 <kfree>
      goto bad;
80108201:	83 c4 10             	add    $0x10,%esp
80108204:	eb cd                	jmp    801081d3 <copyuvm+0xa3>
      panic("copyuvm: page not present");
80108206:	83 ec 0c             	sub    $0xc,%esp
80108209:	68 6e 90 10 80       	push   $0x8010906e
8010820e:	e8 7d 81 ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
80108213:	83 ec 0c             	sub    $0xc,%esp
80108216:	68 54 90 10 80       	push   $0x80109054
8010821b:	e8 70 81 ff ff       	call   80100390 <panic>

80108220 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80108220:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108221:	31 c9                	xor    %ecx,%ecx
{
80108223:	89 e5                	mov    %esp,%ebp
80108225:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80108228:	8b 55 0c             	mov    0xc(%ebp),%edx
8010822b:	8b 45 08             	mov    0x8(%ebp),%eax
8010822e:	e8 9d f7 ff ff       	call   801079d0 <walkpgdir>
  if((*pte & PTE_P) == 0)
80108233:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80108235:	c9                   	leave  
  if((*pte & PTE_U) == 0)
80108236:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80108238:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
8010823d:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80108240:	05 00 00 00 80       	add    $0x80000000,%eax
80108245:	83 fa 05             	cmp    $0x5,%edx
80108248:	ba 00 00 00 00       	mov    $0x0,%edx
8010824d:	0f 45 c2             	cmovne %edx,%eax
}
80108250:	c3                   	ret    
80108251:	eb 0d                	jmp    80108260 <copyout>
80108253:	90                   	nop
80108254:	90                   	nop
80108255:	90                   	nop
80108256:	90                   	nop
80108257:	90                   	nop
80108258:	90                   	nop
80108259:	90                   	nop
8010825a:	90                   	nop
8010825b:	90                   	nop
8010825c:	90                   	nop
8010825d:	90                   	nop
8010825e:	90                   	nop
8010825f:	90                   	nop

80108260 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80108260:	55                   	push   %ebp
80108261:	89 e5                	mov    %esp,%ebp
80108263:	57                   	push   %edi
80108264:	56                   	push   %esi
80108265:	53                   	push   %ebx
80108266:	83 ec 1c             	sub    $0x1c,%esp
80108269:	8b 5d 14             	mov    0x14(%ebp),%ebx
8010826c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010826f:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80108272:	85 db                	test   %ebx,%ebx
80108274:	75 40                	jne    801082b6 <copyout+0x56>
80108276:	eb 70                	jmp    801082e8 <copyout+0x88>
80108278:	90                   	nop
80108279:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80108280:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80108283:	89 f1                	mov    %esi,%ecx
80108285:	29 d1                	sub    %edx,%ecx
80108287:	81 c1 00 10 00 00    	add    $0x1000,%ecx
8010828d:	39 d9                	cmp    %ebx,%ecx
8010828f:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80108292:	29 f2                	sub    %esi,%edx
80108294:	83 ec 04             	sub    $0x4,%esp
80108297:	01 d0                	add    %edx,%eax
80108299:	51                   	push   %ecx
8010829a:	57                   	push   %edi
8010829b:	50                   	push   %eax
8010829c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010829f:	e8 2c d5 ff ff       	call   801057d0 <memmove>
    len -= n;
    buf += n;
801082a4:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  while(len > 0){
801082a7:	83 c4 10             	add    $0x10,%esp
    va = va0 + PGSIZE;
801082aa:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    buf += n;
801082b0:	01 cf                	add    %ecx,%edi
  while(len > 0){
801082b2:	29 cb                	sub    %ecx,%ebx
801082b4:	74 32                	je     801082e8 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
801082b6:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
801082b8:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
801082bb:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801082be:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
801082c4:	56                   	push   %esi
801082c5:	ff 75 08             	pushl  0x8(%ebp)
801082c8:	e8 53 ff ff ff       	call   80108220 <uva2ka>
    if(pa0 == 0)
801082cd:	83 c4 10             	add    $0x10,%esp
801082d0:	85 c0                	test   %eax,%eax
801082d2:	75 ac                	jne    80108280 <copyout+0x20>
  }
  return 0;
}
801082d4:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801082d7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801082dc:	5b                   	pop    %ebx
801082dd:	5e                   	pop    %esi
801082de:	5f                   	pop    %edi
801082df:	5d                   	pop    %ebp
801082e0:	c3                   	ret    
801082e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801082e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801082eb:	31 c0                	xor    %eax,%eax
}
801082ed:	5b                   	pop    %ebx
801082ee:	5e                   	pop    %esi
801082ef:	5f                   	pop    %edi
801082f0:	5d                   	pop    %ebp
801082f1:	c3                   	ret    
