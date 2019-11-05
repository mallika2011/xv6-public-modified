
_ps:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "user.h"
#include "fcntl.h"
#include "fs.h"

int main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 04             	sub    $0x4,%esp

    if (argc > 1)
  11:	83 39 01             	cmpl   $0x1,(%ecx)
  14:	7e 16                	jle    2c <main+0x2c>
    {
        printf(1, "Usage: ps\n");
  16:	50                   	push   %eax
  17:	50                   	push   %eax
  18:	68 58 07 00 00       	push   $0x758
  1d:	6a 01                	push   $0x1
  1f:	e8 dc 03 00 00       	call   400 <printf>
  24:	83 c4 10             	add    $0x10,%esp
    else
    {
        ps();
    }

    exit();
  27:	e8 66 02 00 00       	call   292 <exit>
        ps();
  2c:	e8 11 03 00 00       	call   342 <ps>
  31:	eb f4                	jmp    27 <main+0x27>
  33:	66 90                	xchg   %ax,%ax
  35:	66 90                	xchg   %ax,%ax
  37:	66 90                	xchg   %ax,%ax
  39:	66 90                	xchg   %ax,%ax
  3b:	66 90                	xchg   %ax,%ax
  3d:	66 90                	xchg   %ax,%ax
  3f:	90                   	nop

00000040 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  40:	55                   	push   %ebp
  41:	89 e5                	mov    %esp,%ebp
  43:	53                   	push   %ebx
  44:	8b 45 08             	mov    0x8(%ebp),%eax
  47:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  4a:	89 c2                	mov    %eax,%edx
  4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  50:	83 c1 01             	add    $0x1,%ecx
  53:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  57:	83 c2 01             	add    $0x1,%edx
  5a:	84 db                	test   %bl,%bl
  5c:	88 5a ff             	mov    %bl,-0x1(%edx)
  5f:	75 ef                	jne    50 <strcpy+0x10>
    ;
  return os;
}
  61:	5b                   	pop    %ebx
  62:	5d                   	pop    %ebp
  63:	c3                   	ret    
  64:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  6a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000070 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  70:	55                   	push   %ebp
  71:	89 e5                	mov    %esp,%ebp
  73:	53                   	push   %ebx
  74:	8b 55 08             	mov    0x8(%ebp),%edx
  77:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
  7a:	0f b6 02             	movzbl (%edx),%eax
  7d:	0f b6 19             	movzbl (%ecx),%ebx
  80:	84 c0                	test   %al,%al
  82:	75 1c                	jne    a0 <strcmp+0x30>
  84:	eb 2a                	jmp    b0 <strcmp+0x40>
  86:	8d 76 00             	lea    0x0(%esi),%esi
  89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p++, q++;
  90:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
  93:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
  96:	83 c1 01             	add    $0x1,%ecx
  99:	0f b6 19             	movzbl (%ecx),%ebx
  while(*p && *p == *q)
  9c:	84 c0                	test   %al,%al
  9e:	74 10                	je     b0 <strcmp+0x40>
  a0:	38 d8                	cmp    %bl,%al
  a2:	74 ec                	je     90 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
  a4:	29 d8                	sub    %ebx,%eax
}
  a6:	5b                   	pop    %ebx
  a7:	5d                   	pop    %ebp
  a8:	c3                   	ret    
  a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  b0:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
  b2:	29 d8                	sub    %ebx,%eax
}
  b4:	5b                   	pop    %ebx
  b5:	5d                   	pop    %ebp
  b6:	c3                   	ret    
  b7:	89 f6                	mov    %esi,%esi
  b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000000c0 <strlen>:

uint
strlen(const char *s)
{
  c0:	55                   	push   %ebp
  c1:	89 e5                	mov    %esp,%ebp
  c3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  c6:	80 39 00             	cmpb   $0x0,(%ecx)
  c9:	74 15                	je     e0 <strlen+0x20>
  cb:	31 d2                	xor    %edx,%edx
  cd:	8d 76 00             	lea    0x0(%esi),%esi
  d0:	83 c2 01             	add    $0x1,%edx
  d3:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  d7:	89 d0                	mov    %edx,%eax
  d9:	75 f5                	jne    d0 <strlen+0x10>
    ;
  return n;
}
  db:	5d                   	pop    %ebp
  dc:	c3                   	ret    
  dd:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
  e0:	31 c0                	xor    %eax,%eax
}
  e2:	5d                   	pop    %ebp
  e3:	c3                   	ret    
  e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000000f0 <memset>:

void*
memset(void *dst, int c, uint n)
{
  f0:	55                   	push   %ebp
  f1:	89 e5                	mov    %esp,%ebp
  f3:	57                   	push   %edi
  f4:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  f7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  fd:	89 d7                	mov    %edx,%edi
  ff:	fc                   	cld    
 100:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 102:	89 d0                	mov    %edx,%eax
 104:	5f                   	pop    %edi
 105:	5d                   	pop    %ebp
 106:	c3                   	ret    
 107:	89 f6                	mov    %esi,%esi
 109:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000110 <strchr>:

char*
strchr(const char *s, char c)
{
 110:	55                   	push   %ebp
 111:	89 e5                	mov    %esp,%ebp
 113:	53                   	push   %ebx
 114:	8b 45 08             	mov    0x8(%ebp),%eax
 117:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 11a:	0f b6 10             	movzbl (%eax),%edx
 11d:	84 d2                	test   %dl,%dl
 11f:	74 1d                	je     13e <strchr+0x2e>
    if(*s == c)
 121:	38 d3                	cmp    %dl,%bl
 123:	89 d9                	mov    %ebx,%ecx
 125:	75 0d                	jne    134 <strchr+0x24>
 127:	eb 17                	jmp    140 <strchr+0x30>
 129:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 130:	38 ca                	cmp    %cl,%dl
 132:	74 0c                	je     140 <strchr+0x30>
  for(; *s; s++)
 134:	83 c0 01             	add    $0x1,%eax
 137:	0f b6 10             	movzbl (%eax),%edx
 13a:	84 d2                	test   %dl,%dl
 13c:	75 f2                	jne    130 <strchr+0x20>
      return (char*)s;
  return 0;
 13e:	31 c0                	xor    %eax,%eax
}
 140:	5b                   	pop    %ebx
 141:	5d                   	pop    %ebp
 142:	c3                   	ret    
 143:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 149:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000150 <gets>:

char*
gets(char *buf, int max)
{
 150:	55                   	push   %ebp
 151:	89 e5                	mov    %esp,%ebp
 153:	57                   	push   %edi
 154:	56                   	push   %esi
 155:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 156:	31 f6                	xor    %esi,%esi
 158:	89 f3                	mov    %esi,%ebx
{
 15a:	83 ec 1c             	sub    $0x1c,%esp
 15d:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 160:	eb 2f                	jmp    191 <gets+0x41>
 162:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 168:	8d 45 e7             	lea    -0x19(%ebp),%eax
 16b:	83 ec 04             	sub    $0x4,%esp
 16e:	6a 01                	push   $0x1
 170:	50                   	push   %eax
 171:	6a 00                	push   $0x0
 173:	e8 32 01 00 00       	call   2aa <read>
    if(cc < 1)
 178:	83 c4 10             	add    $0x10,%esp
 17b:	85 c0                	test   %eax,%eax
 17d:	7e 1c                	jle    19b <gets+0x4b>
      break;
    buf[i++] = c;
 17f:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 183:	83 c7 01             	add    $0x1,%edi
 186:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 189:	3c 0a                	cmp    $0xa,%al
 18b:	74 23                	je     1b0 <gets+0x60>
 18d:	3c 0d                	cmp    $0xd,%al
 18f:	74 1f                	je     1b0 <gets+0x60>
  for(i=0; i+1 < max; ){
 191:	83 c3 01             	add    $0x1,%ebx
 194:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 197:	89 fe                	mov    %edi,%esi
 199:	7c cd                	jl     168 <gets+0x18>
 19b:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 19d:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 1a0:	c6 03 00             	movb   $0x0,(%ebx)
}
 1a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
 1a6:	5b                   	pop    %ebx
 1a7:	5e                   	pop    %esi
 1a8:	5f                   	pop    %edi
 1a9:	5d                   	pop    %ebp
 1aa:	c3                   	ret    
 1ab:	90                   	nop
 1ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 1b0:	8b 75 08             	mov    0x8(%ebp),%esi
 1b3:	8b 45 08             	mov    0x8(%ebp),%eax
 1b6:	01 de                	add    %ebx,%esi
 1b8:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 1ba:	c6 03 00             	movb   $0x0,(%ebx)
}
 1bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
 1c0:	5b                   	pop    %ebx
 1c1:	5e                   	pop    %esi
 1c2:	5f                   	pop    %edi
 1c3:	5d                   	pop    %ebp
 1c4:	c3                   	ret    
 1c5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 1c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000001d0 <stat>:

int
stat(const char *n, struct stat *st)
{
 1d0:	55                   	push   %ebp
 1d1:	89 e5                	mov    %esp,%ebp
 1d3:	56                   	push   %esi
 1d4:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1d5:	83 ec 08             	sub    $0x8,%esp
 1d8:	6a 00                	push   $0x0
 1da:	ff 75 08             	pushl  0x8(%ebp)
 1dd:	e8 f0 00 00 00       	call   2d2 <open>
  if(fd < 0)
 1e2:	83 c4 10             	add    $0x10,%esp
 1e5:	85 c0                	test   %eax,%eax
 1e7:	78 27                	js     210 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 1e9:	83 ec 08             	sub    $0x8,%esp
 1ec:	ff 75 0c             	pushl  0xc(%ebp)
 1ef:	89 c3                	mov    %eax,%ebx
 1f1:	50                   	push   %eax
 1f2:	e8 f3 00 00 00       	call   2ea <fstat>
  close(fd);
 1f7:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 1fa:	89 c6                	mov    %eax,%esi
  close(fd);
 1fc:	e8 b9 00 00 00       	call   2ba <close>
  return r;
 201:	83 c4 10             	add    $0x10,%esp
}
 204:	8d 65 f8             	lea    -0x8(%ebp),%esp
 207:	89 f0                	mov    %esi,%eax
 209:	5b                   	pop    %ebx
 20a:	5e                   	pop    %esi
 20b:	5d                   	pop    %ebp
 20c:	c3                   	ret    
 20d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 210:	be ff ff ff ff       	mov    $0xffffffff,%esi
 215:	eb ed                	jmp    204 <stat+0x34>
 217:	89 f6                	mov    %esi,%esi
 219:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000220 <atoi>:

int
atoi(const char *s)
{
 220:	55                   	push   %ebp
 221:	89 e5                	mov    %esp,%ebp
 223:	53                   	push   %ebx
 224:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 227:	0f be 11             	movsbl (%ecx),%edx
 22a:	8d 42 d0             	lea    -0x30(%edx),%eax
 22d:	3c 09                	cmp    $0x9,%al
  n = 0;
 22f:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 234:	77 1f                	ja     255 <atoi+0x35>
 236:	8d 76 00             	lea    0x0(%esi),%esi
 239:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
 240:	8d 04 80             	lea    (%eax,%eax,4),%eax
 243:	83 c1 01             	add    $0x1,%ecx
 246:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 24a:	0f be 11             	movsbl (%ecx),%edx
 24d:	8d 5a d0             	lea    -0x30(%edx),%ebx
 250:	80 fb 09             	cmp    $0x9,%bl
 253:	76 eb                	jbe    240 <atoi+0x20>
  return n;
}
 255:	5b                   	pop    %ebx
 256:	5d                   	pop    %ebp
 257:	c3                   	ret    
 258:	90                   	nop
 259:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000260 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 260:	55                   	push   %ebp
 261:	89 e5                	mov    %esp,%ebp
 263:	56                   	push   %esi
 264:	53                   	push   %ebx
 265:	8b 5d 10             	mov    0x10(%ebp),%ebx
 268:	8b 45 08             	mov    0x8(%ebp),%eax
 26b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 26e:	85 db                	test   %ebx,%ebx
 270:	7e 14                	jle    286 <memmove+0x26>
 272:	31 d2                	xor    %edx,%edx
 274:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 278:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 27c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 27f:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
 282:	39 d3                	cmp    %edx,%ebx
 284:	75 f2                	jne    278 <memmove+0x18>
  return vdst;
}
 286:	5b                   	pop    %ebx
 287:	5e                   	pop    %esi
 288:	5d                   	pop    %ebp
 289:	c3                   	ret    

0000028a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 28a:	b8 01 00 00 00       	mov    $0x1,%eax
 28f:	cd 40                	int    $0x40
 291:	c3                   	ret    

00000292 <exit>:
SYSCALL(exit)
 292:	b8 02 00 00 00       	mov    $0x2,%eax
 297:	cd 40                	int    $0x40
 299:	c3                   	ret    

0000029a <wait>:
SYSCALL(wait)
 29a:	b8 03 00 00 00       	mov    $0x3,%eax
 29f:	cd 40                	int    $0x40
 2a1:	c3                   	ret    

000002a2 <pipe>:
SYSCALL(pipe)
 2a2:	b8 04 00 00 00       	mov    $0x4,%eax
 2a7:	cd 40                	int    $0x40
 2a9:	c3                   	ret    

000002aa <read>:
SYSCALL(read)
 2aa:	b8 05 00 00 00       	mov    $0x5,%eax
 2af:	cd 40                	int    $0x40
 2b1:	c3                   	ret    

000002b2 <write>:
SYSCALL(write)
 2b2:	b8 10 00 00 00       	mov    $0x10,%eax
 2b7:	cd 40                	int    $0x40
 2b9:	c3                   	ret    

000002ba <close>:
SYSCALL(close)
 2ba:	b8 15 00 00 00       	mov    $0x15,%eax
 2bf:	cd 40                	int    $0x40
 2c1:	c3                   	ret    

000002c2 <kill>:
SYSCALL(kill)
 2c2:	b8 06 00 00 00       	mov    $0x6,%eax
 2c7:	cd 40                	int    $0x40
 2c9:	c3                   	ret    

000002ca <exec>:
SYSCALL(exec)
 2ca:	b8 07 00 00 00       	mov    $0x7,%eax
 2cf:	cd 40                	int    $0x40
 2d1:	c3                   	ret    

000002d2 <open>:
SYSCALL(open)
 2d2:	b8 0f 00 00 00       	mov    $0xf,%eax
 2d7:	cd 40                	int    $0x40
 2d9:	c3                   	ret    

000002da <mknod>:
SYSCALL(mknod)
 2da:	b8 11 00 00 00       	mov    $0x11,%eax
 2df:	cd 40                	int    $0x40
 2e1:	c3                   	ret    

000002e2 <unlink>:
SYSCALL(unlink)
 2e2:	b8 12 00 00 00       	mov    $0x12,%eax
 2e7:	cd 40                	int    $0x40
 2e9:	c3                   	ret    

000002ea <fstat>:
SYSCALL(fstat)
 2ea:	b8 08 00 00 00       	mov    $0x8,%eax
 2ef:	cd 40                	int    $0x40
 2f1:	c3                   	ret    

000002f2 <link>:
SYSCALL(link)
 2f2:	b8 13 00 00 00       	mov    $0x13,%eax
 2f7:	cd 40                	int    $0x40
 2f9:	c3                   	ret    

000002fa <mkdir>:
SYSCALL(mkdir)
 2fa:	b8 14 00 00 00       	mov    $0x14,%eax
 2ff:	cd 40                	int    $0x40
 301:	c3                   	ret    

00000302 <chdir>:
SYSCALL(chdir)
 302:	b8 09 00 00 00       	mov    $0x9,%eax
 307:	cd 40                	int    $0x40
 309:	c3                   	ret    

0000030a <dup>:
SYSCALL(dup)
 30a:	b8 0a 00 00 00       	mov    $0xa,%eax
 30f:	cd 40                	int    $0x40
 311:	c3                   	ret    

00000312 <getpid>:
SYSCALL(getpid)
 312:	b8 0b 00 00 00       	mov    $0xb,%eax
 317:	cd 40                	int    $0x40
 319:	c3                   	ret    

0000031a <sbrk>:
SYSCALL(sbrk)
 31a:	b8 0c 00 00 00       	mov    $0xc,%eax
 31f:	cd 40                	int    $0x40
 321:	c3                   	ret    

00000322 <sleep>:
SYSCALL(sleep)
 322:	b8 0d 00 00 00       	mov    $0xd,%eax
 327:	cd 40                	int    $0x40
 329:	c3                   	ret    

0000032a <uptime>:
SYSCALL(uptime)
 32a:	b8 0e 00 00 00       	mov    $0xe,%eax
 32f:	cd 40                	int    $0x40
 331:	c3                   	ret    

00000332 <waitx>:
SYSCALL(waitx)
 332:	b8 16 00 00 00       	mov    $0x16,%eax
 337:	cd 40                	int    $0x40
 339:	c3                   	ret    

0000033a <getpinfo>:
SYSCALL(getpinfo)
 33a:	b8 17 00 00 00       	mov    $0x17,%eax
 33f:	cd 40                	int    $0x40
 341:	c3                   	ret    

00000342 <ps>:
SYSCALL(ps)
 342:	b8 18 00 00 00       	mov    $0x18,%eax
 347:	cd 40                	int    $0x40
 349:	c3                   	ret    

0000034a <set_priority>:
SYSCALL(set_priority)
 34a:	b8 19 00 00 00       	mov    $0x19,%eax
 34f:	cd 40                	int    $0x40
 351:	c3                   	ret    
 352:	66 90                	xchg   %ax,%ax
 354:	66 90                	xchg   %ax,%ax
 356:	66 90                	xchg   %ax,%ax
 358:	66 90                	xchg   %ax,%ax
 35a:	66 90                	xchg   %ax,%ax
 35c:	66 90                	xchg   %ax,%ax
 35e:	66 90                	xchg   %ax,%ax

00000360 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 360:	55                   	push   %ebp
 361:	89 e5                	mov    %esp,%ebp
 363:	57                   	push   %edi
 364:	56                   	push   %esi
 365:	53                   	push   %ebx
 366:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 369:	85 d2                	test   %edx,%edx
{
 36b:	89 45 c0             	mov    %eax,-0x40(%ebp)
    neg = 1;
    x = -xx;
 36e:	89 d0                	mov    %edx,%eax
  if(sgn && xx < 0){
 370:	79 76                	jns    3e8 <printint+0x88>
 372:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 376:	74 70                	je     3e8 <printint+0x88>
    x = -xx;
 378:	f7 d8                	neg    %eax
    neg = 1;
 37a:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 381:	31 f6                	xor    %esi,%esi
 383:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 386:	eb 0a                	jmp    392 <printint+0x32>
 388:	90                   	nop
 389:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  do{
    buf[i++] = digits[x % base];
 390:	89 fe                	mov    %edi,%esi
 392:	31 d2                	xor    %edx,%edx
 394:	8d 7e 01             	lea    0x1(%esi),%edi
 397:	f7 f1                	div    %ecx
 399:	0f b6 92 6c 07 00 00 	movzbl 0x76c(%edx),%edx
  }while((x /= base) != 0);
 3a0:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
 3a2:	88 14 3b             	mov    %dl,(%ebx,%edi,1)
  }while((x /= base) != 0);
 3a5:	75 e9                	jne    390 <printint+0x30>
  if(neg)
 3a7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 3aa:	85 c0                	test   %eax,%eax
 3ac:	74 08                	je     3b6 <printint+0x56>
    buf[i++] = '-';
 3ae:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
 3b3:	8d 7e 02             	lea    0x2(%esi),%edi
 3b6:	8d 74 3d d7          	lea    -0x29(%ebp,%edi,1),%esi
 3ba:	8b 7d c0             	mov    -0x40(%ebp),%edi
 3bd:	8d 76 00             	lea    0x0(%esi),%esi
 3c0:	0f b6 06             	movzbl (%esi),%eax
  write(fd, &c, 1);
 3c3:	83 ec 04             	sub    $0x4,%esp
 3c6:	83 ee 01             	sub    $0x1,%esi
 3c9:	6a 01                	push   $0x1
 3cb:	53                   	push   %ebx
 3cc:	57                   	push   %edi
 3cd:	88 45 d7             	mov    %al,-0x29(%ebp)
 3d0:	e8 dd fe ff ff       	call   2b2 <write>

  while(--i >= 0)
 3d5:	83 c4 10             	add    $0x10,%esp
 3d8:	39 de                	cmp    %ebx,%esi
 3da:	75 e4                	jne    3c0 <printint+0x60>
    putc(fd, buf[i]);
}
 3dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3df:	5b                   	pop    %ebx
 3e0:	5e                   	pop    %esi
 3e1:	5f                   	pop    %edi
 3e2:	5d                   	pop    %ebp
 3e3:	c3                   	ret    
 3e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 3e8:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 3ef:	eb 90                	jmp    381 <printint+0x21>
 3f1:	eb 0d                	jmp    400 <printf>
 3f3:	90                   	nop
 3f4:	90                   	nop
 3f5:	90                   	nop
 3f6:	90                   	nop
 3f7:	90                   	nop
 3f8:	90                   	nop
 3f9:	90                   	nop
 3fa:	90                   	nop
 3fb:	90                   	nop
 3fc:	90                   	nop
 3fd:	90                   	nop
 3fe:	90                   	nop
 3ff:	90                   	nop

00000400 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 400:	55                   	push   %ebp
 401:	89 e5                	mov    %esp,%ebp
 403:	57                   	push   %edi
 404:	56                   	push   %esi
 405:	53                   	push   %ebx
 406:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 409:	8b 75 0c             	mov    0xc(%ebp),%esi
 40c:	0f b6 1e             	movzbl (%esi),%ebx
 40f:	84 db                	test   %bl,%bl
 411:	0f 84 b3 00 00 00    	je     4ca <printf+0xca>
  ap = (uint*)(void*)&fmt + 1;
 417:	8d 45 10             	lea    0x10(%ebp),%eax
 41a:	83 c6 01             	add    $0x1,%esi
  state = 0;
 41d:	31 ff                	xor    %edi,%edi
  ap = (uint*)(void*)&fmt + 1;
 41f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 422:	eb 2f                	jmp    453 <printf+0x53>
 424:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 428:	83 f8 25             	cmp    $0x25,%eax
 42b:	0f 84 a7 00 00 00    	je     4d8 <printf+0xd8>
  write(fd, &c, 1);
 431:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 434:	83 ec 04             	sub    $0x4,%esp
 437:	88 5d e2             	mov    %bl,-0x1e(%ebp)
 43a:	6a 01                	push   $0x1
 43c:	50                   	push   %eax
 43d:	ff 75 08             	pushl  0x8(%ebp)
 440:	e8 6d fe ff ff       	call   2b2 <write>
 445:	83 c4 10             	add    $0x10,%esp
 448:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
 44b:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 44f:	84 db                	test   %bl,%bl
 451:	74 77                	je     4ca <printf+0xca>
    if(state == 0){
 453:	85 ff                	test   %edi,%edi
    c = fmt[i] & 0xff;
 455:	0f be cb             	movsbl %bl,%ecx
 458:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 45b:	74 cb                	je     428 <printf+0x28>
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 45d:	83 ff 25             	cmp    $0x25,%edi
 460:	75 e6                	jne    448 <printf+0x48>
      if(c == 'd'){
 462:	83 f8 64             	cmp    $0x64,%eax
 465:	0f 84 05 01 00 00    	je     570 <printf+0x170>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 46b:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 471:	83 f9 70             	cmp    $0x70,%ecx
 474:	74 72                	je     4e8 <printf+0xe8>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 476:	83 f8 73             	cmp    $0x73,%eax
 479:	0f 84 99 00 00 00    	je     518 <printf+0x118>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 47f:	83 f8 63             	cmp    $0x63,%eax
 482:	0f 84 08 01 00 00    	je     590 <printf+0x190>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 488:	83 f8 25             	cmp    $0x25,%eax
 48b:	0f 84 ef 00 00 00    	je     580 <printf+0x180>
  write(fd, &c, 1);
 491:	8d 45 e7             	lea    -0x19(%ebp),%eax
 494:	83 ec 04             	sub    $0x4,%esp
 497:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 49b:	6a 01                	push   $0x1
 49d:	50                   	push   %eax
 49e:	ff 75 08             	pushl  0x8(%ebp)
 4a1:	e8 0c fe ff ff       	call   2b2 <write>
 4a6:	83 c4 0c             	add    $0xc,%esp
 4a9:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 4ac:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 4af:	6a 01                	push   $0x1
 4b1:	50                   	push   %eax
 4b2:	ff 75 08             	pushl  0x8(%ebp)
 4b5:	83 c6 01             	add    $0x1,%esi
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 4b8:	31 ff                	xor    %edi,%edi
  write(fd, &c, 1);
 4ba:	e8 f3 fd ff ff       	call   2b2 <write>
  for(i = 0; fmt[i]; i++){
 4bf:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
  write(fd, &c, 1);
 4c3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 4c6:	84 db                	test   %bl,%bl
 4c8:	75 89                	jne    453 <printf+0x53>
    }
  }
}
 4ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4cd:	5b                   	pop    %ebx
 4ce:	5e                   	pop    %esi
 4cf:	5f                   	pop    %edi
 4d0:	5d                   	pop    %ebp
 4d1:	c3                   	ret    
 4d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        state = '%';
 4d8:	bf 25 00 00 00       	mov    $0x25,%edi
 4dd:	e9 66 ff ff ff       	jmp    448 <printf+0x48>
 4e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 4e8:	83 ec 0c             	sub    $0xc,%esp
 4eb:	b9 10 00 00 00       	mov    $0x10,%ecx
 4f0:	6a 00                	push   $0x0
 4f2:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 4f5:	8b 45 08             	mov    0x8(%ebp),%eax
 4f8:	8b 17                	mov    (%edi),%edx
 4fa:	e8 61 fe ff ff       	call   360 <printint>
        ap++;
 4ff:	89 f8                	mov    %edi,%eax
 501:	83 c4 10             	add    $0x10,%esp
      state = 0;
 504:	31 ff                	xor    %edi,%edi
        ap++;
 506:	83 c0 04             	add    $0x4,%eax
 509:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 50c:	e9 37 ff ff ff       	jmp    448 <printf+0x48>
 511:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 518:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 51b:	8b 08                	mov    (%eax),%ecx
        ap++;
 51d:	83 c0 04             	add    $0x4,%eax
 520:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        if(s == 0)
 523:	85 c9                	test   %ecx,%ecx
 525:	0f 84 8e 00 00 00    	je     5b9 <printf+0x1b9>
        while(*s != 0){
 52b:	0f b6 01             	movzbl (%ecx),%eax
      state = 0;
 52e:	31 ff                	xor    %edi,%edi
        s = (char*)*ap;
 530:	89 cb                	mov    %ecx,%ebx
        while(*s != 0){
 532:	84 c0                	test   %al,%al
 534:	0f 84 0e ff ff ff    	je     448 <printf+0x48>
 53a:	89 75 d0             	mov    %esi,-0x30(%ebp)
 53d:	89 de                	mov    %ebx,%esi
 53f:	8b 5d 08             	mov    0x8(%ebp),%ebx
 542:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 545:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 548:	83 ec 04             	sub    $0x4,%esp
          s++;
 54b:	83 c6 01             	add    $0x1,%esi
 54e:	88 45 e3             	mov    %al,-0x1d(%ebp)
  write(fd, &c, 1);
 551:	6a 01                	push   $0x1
 553:	57                   	push   %edi
 554:	53                   	push   %ebx
 555:	e8 58 fd ff ff       	call   2b2 <write>
        while(*s != 0){
 55a:	0f b6 06             	movzbl (%esi),%eax
 55d:	83 c4 10             	add    $0x10,%esp
 560:	84 c0                	test   %al,%al
 562:	75 e4                	jne    548 <printf+0x148>
 564:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
 567:	31 ff                	xor    %edi,%edi
 569:	e9 da fe ff ff       	jmp    448 <printf+0x48>
 56e:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 10, 1);
 570:	83 ec 0c             	sub    $0xc,%esp
 573:	b9 0a 00 00 00       	mov    $0xa,%ecx
 578:	6a 01                	push   $0x1
 57a:	e9 73 ff ff ff       	jmp    4f2 <printf+0xf2>
 57f:	90                   	nop
  write(fd, &c, 1);
 580:	83 ec 04             	sub    $0x4,%esp
 583:	88 5d e5             	mov    %bl,-0x1b(%ebp)
 586:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 589:	6a 01                	push   $0x1
 58b:	e9 21 ff ff ff       	jmp    4b1 <printf+0xb1>
        putc(fd, *ap);
 590:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  write(fd, &c, 1);
 593:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 596:	8b 07                	mov    (%edi),%eax
  write(fd, &c, 1);
 598:	6a 01                	push   $0x1
        ap++;
 59a:	83 c7 04             	add    $0x4,%edi
        putc(fd, *ap);
 59d:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 5a0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 5a3:	50                   	push   %eax
 5a4:	ff 75 08             	pushl  0x8(%ebp)
 5a7:	e8 06 fd ff ff       	call   2b2 <write>
        ap++;
 5ac:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 5af:	83 c4 10             	add    $0x10,%esp
      state = 0;
 5b2:	31 ff                	xor    %edi,%edi
 5b4:	e9 8f fe ff ff       	jmp    448 <printf+0x48>
          s = "(null)";
 5b9:	bb 63 07 00 00       	mov    $0x763,%ebx
        while(*s != 0){
 5be:	b8 28 00 00 00       	mov    $0x28,%eax
 5c3:	e9 72 ff ff ff       	jmp    53a <printf+0x13a>
 5c8:	66 90                	xchg   %ax,%ax
 5ca:	66 90                	xchg   %ax,%ax
 5cc:	66 90                	xchg   %ax,%ax
 5ce:	66 90                	xchg   %ax,%ax

000005d0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5d0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5d1:	a1 10 0a 00 00       	mov    0xa10,%eax
{
 5d6:	89 e5                	mov    %esp,%ebp
 5d8:	57                   	push   %edi
 5d9:	56                   	push   %esi
 5da:	53                   	push   %ebx
 5db:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 5de:	8d 4b f8             	lea    -0x8(%ebx),%ecx
 5e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5e8:	39 c8                	cmp    %ecx,%eax
 5ea:	8b 10                	mov    (%eax),%edx
 5ec:	73 32                	jae    620 <free+0x50>
 5ee:	39 d1                	cmp    %edx,%ecx
 5f0:	72 04                	jb     5f6 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5f2:	39 d0                	cmp    %edx,%eax
 5f4:	72 32                	jb     628 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
 5f6:	8b 73 fc             	mov    -0x4(%ebx),%esi
 5f9:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 5fc:	39 fa                	cmp    %edi,%edx
 5fe:	74 30                	je     630 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 600:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 603:	8b 50 04             	mov    0x4(%eax),%edx
 606:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 609:	39 f1                	cmp    %esi,%ecx
 60b:	74 3a                	je     647 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 60d:	89 08                	mov    %ecx,(%eax)
  freep = p;
 60f:	a3 10 0a 00 00       	mov    %eax,0xa10
}
 614:	5b                   	pop    %ebx
 615:	5e                   	pop    %esi
 616:	5f                   	pop    %edi
 617:	5d                   	pop    %ebp
 618:	c3                   	ret    
 619:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 620:	39 d0                	cmp    %edx,%eax
 622:	72 04                	jb     628 <free+0x58>
 624:	39 d1                	cmp    %edx,%ecx
 626:	72 ce                	jb     5f6 <free+0x26>
{
 628:	89 d0                	mov    %edx,%eax
 62a:	eb bc                	jmp    5e8 <free+0x18>
 62c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 630:	03 72 04             	add    0x4(%edx),%esi
 633:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 636:	8b 10                	mov    (%eax),%edx
 638:	8b 12                	mov    (%edx),%edx
 63a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 63d:	8b 50 04             	mov    0x4(%eax),%edx
 640:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 643:	39 f1                	cmp    %esi,%ecx
 645:	75 c6                	jne    60d <free+0x3d>
    p->s.size += bp->s.size;
 647:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 64a:	a3 10 0a 00 00       	mov    %eax,0xa10
    p->s.size += bp->s.size;
 64f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 652:	8b 53 f8             	mov    -0x8(%ebx),%edx
 655:	89 10                	mov    %edx,(%eax)
}
 657:	5b                   	pop    %ebx
 658:	5e                   	pop    %esi
 659:	5f                   	pop    %edi
 65a:	5d                   	pop    %ebp
 65b:	c3                   	ret    
 65c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000660 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 660:	55                   	push   %ebp
 661:	89 e5                	mov    %esp,%ebp
 663:	57                   	push   %edi
 664:	56                   	push   %esi
 665:	53                   	push   %ebx
 666:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 669:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 66c:	8b 15 10 0a 00 00    	mov    0xa10,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 672:	8d 78 07             	lea    0x7(%eax),%edi
 675:	c1 ef 03             	shr    $0x3,%edi
 678:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 67b:	85 d2                	test   %edx,%edx
 67d:	0f 84 9d 00 00 00    	je     720 <malloc+0xc0>
 683:	8b 02                	mov    (%edx),%eax
 685:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 688:	39 cf                	cmp    %ecx,%edi
 68a:	76 6c                	jbe    6f8 <malloc+0x98>
 68c:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 692:	bb 00 10 00 00       	mov    $0x1000,%ebx
 697:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 69a:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 6a1:	eb 0e                	jmp    6b1 <malloc+0x51>
 6a3:	90                   	nop
 6a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6a8:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 6aa:	8b 48 04             	mov    0x4(%eax),%ecx
 6ad:	39 f9                	cmp    %edi,%ecx
 6af:	73 47                	jae    6f8 <malloc+0x98>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 6b1:	39 05 10 0a 00 00    	cmp    %eax,0xa10
 6b7:	89 c2                	mov    %eax,%edx
 6b9:	75 ed                	jne    6a8 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
 6bb:	83 ec 0c             	sub    $0xc,%esp
 6be:	56                   	push   %esi
 6bf:	e8 56 fc ff ff       	call   31a <sbrk>
  if(p == (char*)-1)
 6c4:	83 c4 10             	add    $0x10,%esp
 6c7:	83 f8 ff             	cmp    $0xffffffff,%eax
 6ca:	74 1c                	je     6e8 <malloc+0x88>
  hp->s.size = nu;
 6cc:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 6cf:	83 ec 0c             	sub    $0xc,%esp
 6d2:	83 c0 08             	add    $0x8,%eax
 6d5:	50                   	push   %eax
 6d6:	e8 f5 fe ff ff       	call   5d0 <free>
  return freep;
 6db:	8b 15 10 0a 00 00    	mov    0xa10,%edx
      if((p = morecore(nunits)) == 0)
 6e1:	83 c4 10             	add    $0x10,%esp
 6e4:	85 d2                	test   %edx,%edx
 6e6:	75 c0                	jne    6a8 <malloc+0x48>
        return 0;
  }
}
 6e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 6eb:	31 c0                	xor    %eax,%eax
}
 6ed:	5b                   	pop    %ebx
 6ee:	5e                   	pop    %esi
 6ef:	5f                   	pop    %edi
 6f0:	5d                   	pop    %ebp
 6f1:	c3                   	ret    
 6f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 6f8:	39 cf                	cmp    %ecx,%edi
 6fa:	74 54                	je     750 <malloc+0xf0>
        p->s.size -= nunits;
 6fc:	29 f9                	sub    %edi,%ecx
 6fe:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 701:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 704:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 707:	89 15 10 0a 00 00    	mov    %edx,0xa10
}
 70d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 710:	83 c0 08             	add    $0x8,%eax
}
 713:	5b                   	pop    %ebx
 714:	5e                   	pop    %esi
 715:	5f                   	pop    %edi
 716:	5d                   	pop    %ebp
 717:	c3                   	ret    
 718:	90                   	nop
 719:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    base.s.ptr = freep = prevp = &base;
 720:	c7 05 10 0a 00 00 14 	movl   $0xa14,0xa10
 727:	0a 00 00 
 72a:	c7 05 14 0a 00 00 14 	movl   $0xa14,0xa14
 731:	0a 00 00 
    base.s.size = 0;
 734:	b8 14 0a 00 00       	mov    $0xa14,%eax
 739:	c7 05 18 0a 00 00 00 	movl   $0x0,0xa18
 740:	00 00 00 
 743:	e9 44 ff ff ff       	jmp    68c <malloc+0x2c>
 748:	90                   	nop
 749:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        prevp->s.ptr = p->s.ptr;
 750:	8b 08                	mov    (%eax),%ecx
 752:	89 0a                	mov    %ecx,(%edx)
 754:	eb b1                	jmp    707 <malloc+0xa7>
