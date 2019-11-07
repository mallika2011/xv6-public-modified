
_loop:     file format elf32-i386


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
   d:	57                   	push   %edi
   e:	56                   	push   %esi
   f:	53                   	push   %ebx
  10:	51                   	push   %ecx
  11:	83 ec 28             	sub    $0x28,%esp
  14:	8b 41 04             	mov    0x4(%ecx),%eax
  17:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    //     {
    //         for (volatile long long int i = 0; i < 10000; i++);
    //         printf(1,"CHILD   %d  DONE \n", getpid());
    //     }
    // }
    int p=fork();
  1a:	e8 db 02 00 00       	call   2fa <fork>
    if(p==0)
  1f:	85 c0                	test   %eax,%eax
  21:	75 5e                	jne    81 <main+0x81>
    {
            long long int x = 0;

        for (volatile long long int i = 0; i < 1000000*atoi(argv[1]); i++)
  23:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  2a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  38:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  3b:	83 ec 0c             	sub    $0xc,%esp
  3e:	ff 70 04             	pushl  0x4(%eax)
  41:	e8 4a 02 00 00       	call   290 <atoi>
  46:	69 c0 40 42 0f 00    	imul   $0xf4240,%eax,%eax
  4c:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  4f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  52:	83 c4 10             	add    $0x10,%esp
  55:	89 c7                	mov    %eax,%edi
  57:	c1 ff 1f             	sar    $0x1f,%edi
  5a:	39 df                	cmp    %ebx,%edi
  5c:	7f 36                	jg     94 <main+0x94>
  5e:	7d 30                	jge    90 <main+0x90>
            {
                x++;
            }
        printf(1,"********************%d*****************************\n", atoi(argv[1]));
  60:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  63:	83 ec 0c             	sub    $0xc,%esp
  66:	ff 70 04             	pushl  0x4(%eax)
  69:	e8 22 02 00 00       	call   290 <atoi>
  6e:	83 c4 0c             	add    $0xc,%esp
  71:	50                   	push   %eax
  72:	68 c8 07 00 00       	push   $0x7c8
  77:	6a 01                	push   $0x1
  79:	e8 f2 03 00 00       	call   470 <printf>
  7e:	83 c4 10             	add    $0x10,%esp
    }
    exit();
  81:	e8 7c 02 00 00       	call   302 <exit>
  86:	8d 76 00             	lea    0x0(%esi),%esi
  89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        for (volatile long long int i = 0; i < 1000000*atoi(argv[1]); i++)
  90:	39 c8                	cmp    %ecx,%eax
  92:	76 cc                	jbe    60 <main+0x60>
  94:	8b 45 e0             	mov    -0x20(%ebp),%eax
  97:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  9a:	83 c0 01             	add    $0x1,%eax
  9d:	83 d2 00             	adc    $0x0,%edx
  a0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  a3:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  a6:	eb 90                	jmp    38 <main+0x38>
  a8:	66 90                	xchg   %ax,%ax
  aa:	66 90                	xchg   %ax,%ax
  ac:	66 90                	xchg   %ax,%ax
  ae:	66 90                	xchg   %ax,%ax

000000b0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  b0:	55                   	push   %ebp
  b1:	89 e5                	mov    %esp,%ebp
  b3:	53                   	push   %ebx
  b4:	8b 45 08             	mov    0x8(%ebp),%eax
  b7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  ba:	89 c2                	mov    %eax,%edx
  bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  c0:	83 c1 01             	add    $0x1,%ecx
  c3:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  c7:	83 c2 01             	add    $0x1,%edx
  ca:	84 db                	test   %bl,%bl
  cc:	88 5a ff             	mov    %bl,-0x1(%edx)
  cf:	75 ef                	jne    c0 <strcpy+0x10>
    ;
  return os;
}
  d1:	5b                   	pop    %ebx
  d2:	5d                   	pop    %ebp
  d3:	c3                   	ret    
  d4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  da:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000000e0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  e0:	55                   	push   %ebp
  e1:	89 e5                	mov    %esp,%ebp
  e3:	53                   	push   %ebx
  e4:	8b 55 08             	mov    0x8(%ebp),%edx
  e7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
  ea:	0f b6 02             	movzbl (%edx),%eax
  ed:	0f b6 19             	movzbl (%ecx),%ebx
  f0:	84 c0                	test   %al,%al
  f2:	75 1c                	jne    110 <strcmp+0x30>
  f4:	eb 2a                	jmp    120 <strcmp+0x40>
  f6:	8d 76 00             	lea    0x0(%esi),%esi
  f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p++, q++;
 100:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 103:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
 106:	83 c1 01             	add    $0x1,%ecx
 109:	0f b6 19             	movzbl (%ecx),%ebx
  while(*p && *p == *q)
 10c:	84 c0                	test   %al,%al
 10e:	74 10                	je     120 <strcmp+0x40>
 110:	38 d8                	cmp    %bl,%al
 112:	74 ec                	je     100 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
 114:	29 d8                	sub    %ebx,%eax
}
 116:	5b                   	pop    %ebx
 117:	5d                   	pop    %ebp
 118:	c3                   	ret    
 119:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 120:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 122:	29 d8                	sub    %ebx,%eax
}
 124:	5b                   	pop    %ebx
 125:	5d                   	pop    %ebp
 126:	c3                   	ret    
 127:	89 f6                	mov    %esi,%esi
 129:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000130 <strlen>:

uint
strlen(const char *s)
{
 130:	55                   	push   %ebp
 131:	89 e5                	mov    %esp,%ebp
 133:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 136:	80 39 00             	cmpb   $0x0,(%ecx)
 139:	74 15                	je     150 <strlen+0x20>
 13b:	31 d2                	xor    %edx,%edx
 13d:	8d 76 00             	lea    0x0(%esi),%esi
 140:	83 c2 01             	add    $0x1,%edx
 143:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 147:	89 d0                	mov    %edx,%eax
 149:	75 f5                	jne    140 <strlen+0x10>
    ;
  return n;
}
 14b:	5d                   	pop    %ebp
 14c:	c3                   	ret    
 14d:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 150:	31 c0                	xor    %eax,%eax
}
 152:	5d                   	pop    %ebp
 153:	c3                   	ret    
 154:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 15a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000160 <memset>:

void*
memset(void *dst, int c, uint n)
{
 160:	55                   	push   %ebp
 161:	89 e5                	mov    %esp,%ebp
 163:	57                   	push   %edi
 164:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 167:	8b 4d 10             	mov    0x10(%ebp),%ecx
 16a:	8b 45 0c             	mov    0xc(%ebp),%eax
 16d:	89 d7                	mov    %edx,%edi
 16f:	fc                   	cld    
 170:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 172:	89 d0                	mov    %edx,%eax
 174:	5f                   	pop    %edi
 175:	5d                   	pop    %ebp
 176:	c3                   	ret    
 177:	89 f6                	mov    %esi,%esi
 179:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000180 <strchr>:

char*
strchr(const char *s, char c)
{
 180:	55                   	push   %ebp
 181:	89 e5                	mov    %esp,%ebp
 183:	53                   	push   %ebx
 184:	8b 45 08             	mov    0x8(%ebp),%eax
 187:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 18a:	0f b6 10             	movzbl (%eax),%edx
 18d:	84 d2                	test   %dl,%dl
 18f:	74 1d                	je     1ae <strchr+0x2e>
    if(*s == c)
 191:	38 d3                	cmp    %dl,%bl
 193:	89 d9                	mov    %ebx,%ecx
 195:	75 0d                	jne    1a4 <strchr+0x24>
 197:	eb 17                	jmp    1b0 <strchr+0x30>
 199:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1a0:	38 ca                	cmp    %cl,%dl
 1a2:	74 0c                	je     1b0 <strchr+0x30>
  for(; *s; s++)
 1a4:	83 c0 01             	add    $0x1,%eax
 1a7:	0f b6 10             	movzbl (%eax),%edx
 1aa:	84 d2                	test   %dl,%dl
 1ac:	75 f2                	jne    1a0 <strchr+0x20>
      return (char*)s;
  return 0;
 1ae:	31 c0                	xor    %eax,%eax
}
 1b0:	5b                   	pop    %ebx
 1b1:	5d                   	pop    %ebp
 1b2:	c3                   	ret    
 1b3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 1b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000001c0 <gets>:

char*
gets(char *buf, int max)
{
 1c0:	55                   	push   %ebp
 1c1:	89 e5                	mov    %esp,%ebp
 1c3:	57                   	push   %edi
 1c4:	56                   	push   %esi
 1c5:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1c6:	31 f6                	xor    %esi,%esi
 1c8:	89 f3                	mov    %esi,%ebx
{
 1ca:	83 ec 1c             	sub    $0x1c,%esp
 1cd:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 1d0:	eb 2f                	jmp    201 <gets+0x41>
 1d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 1d8:	8d 45 e7             	lea    -0x19(%ebp),%eax
 1db:	83 ec 04             	sub    $0x4,%esp
 1de:	6a 01                	push   $0x1
 1e0:	50                   	push   %eax
 1e1:	6a 00                	push   $0x0
 1e3:	e8 32 01 00 00       	call   31a <read>
    if(cc < 1)
 1e8:	83 c4 10             	add    $0x10,%esp
 1eb:	85 c0                	test   %eax,%eax
 1ed:	7e 1c                	jle    20b <gets+0x4b>
      break;
    buf[i++] = c;
 1ef:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 1f3:	83 c7 01             	add    $0x1,%edi
 1f6:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 1f9:	3c 0a                	cmp    $0xa,%al
 1fb:	74 23                	je     220 <gets+0x60>
 1fd:	3c 0d                	cmp    $0xd,%al
 1ff:	74 1f                	je     220 <gets+0x60>
  for(i=0; i+1 < max; ){
 201:	83 c3 01             	add    $0x1,%ebx
 204:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 207:	89 fe                	mov    %edi,%esi
 209:	7c cd                	jl     1d8 <gets+0x18>
 20b:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 20d:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 210:	c6 03 00             	movb   $0x0,(%ebx)
}
 213:	8d 65 f4             	lea    -0xc(%ebp),%esp
 216:	5b                   	pop    %ebx
 217:	5e                   	pop    %esi
 218:	5f                   	pop    %edi
 219:	5d                   	pop    %ebp
 21a:	c3                   	ret    
 21b:	90                   	nop
 21c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 220:	8b 75 08             	mov    0x8(%ebp),%esi
 223:	8b 45 08             	mov    0x8(%ebp),%eax
 226:	01 de                	add    %ebx,%esi
 228:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 22a:	c6 03 00             	movb   $0x0,(%ebx)
}
 22d:	8d 65 f4             	lea    -0xc(%ebp),%esp
 230:	5b                   	pop    %ebx
 231:	5e                   	pop    %esi
 232:	5f                   	pop    %edi
 233:	5d                   	pop    %ebp
 234:	c3                   	ret    
 235:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 239:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000240 <stat>:

int
stat(const char *n, struct stat *st)
{
 240:	55                   	push   %ebp
 241:	89 e5                	mov    %esp,%ebp
 243:	56                   	push   %esi
 244:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 245:	83 ec 08             	sub    $0x8,%esp
 248:	6a 00                	push   $0x0
 24a:	ff 75 08             	pushl  0x8(%ebp)
 24d:	e8 f0 00 00 00       	call   342 <open>
  if(fd < 0)
 252:	83 c4 10             	add    $0x10,%esp
 255:	85 c0                	test   %eax,%eax
 257:	78 27                	js     280 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 259:	83 ec 08             	sub    $0x8,%esp
 25c:	ff 75 0c             	pushl  0xc(%ebp)
 25f:	89 c3                	mov    %eax,%ebx
 261:	50                   	push   %eax
 262:	e8 f3 00 00 00       	call   35a <fstat>
  close(fd);
 267:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 26a:	89 c6                	mov    %eax,%esi
  close(fd);
 26c:	e8 b9 00 00 00       	call   32a <close>
  return r;
 271:	83 c4 10             	add    $0x10,%esp
}
 274:	8d 65 f8             	lea    -0x8(%ebp),%esp
 277:	89 f0                	mov    %esi,%eax
 279:	5b                   	pop    %ebx
 27a:	5e                   	pop    %esi
 27b:	5d                   	pop    %ebp
 27c:	c3                   	ret    
 27d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 280:	be ff ff ff ff       	mov    $0xffffffff,%esi
 285:	eb ed                	jmp    274 <stat+0x34>
 287:	89 f6                	mov    %esi,%esi
 289:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000290 <atoi>:

int
atoi(const char *s)
{
 290:	55                   	push   %ebp
 291:	89 e5                	mov    %esp,%ebp
 293:	53                   	push   %ebx
 294:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 297:	0f be 11             	movsbl (%ecx),%edx
 29a:	8d 42 d0             	lea    -0x30(%edx),%eax
 29d:	3c 09                	cmp    $0x9,%al
  n = 0;
 29f:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 2a4:	77 1f                	ja     2c5 <atoi+0x35>
 2a6:	8d 76 00             	lea    0x0(%esi),%esi
 2a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
 2b0:	8d 04 80             	lea    (%eax,%eax,4),%eax
 2b3:	83 c1 01             	add    $0x1,%ecx
 2b6:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 2ba:	0f be 11             	movsbl (%ecx),%edx
 2bd:	8d 5a d0             	lea    -0x30(%edx),%ebx
 2c0:	80 fb 09             	cmp    $0x9,%bl
 2c3:	76 eb                	jbe    2b0 <atoi+0x20>
  return n;
}
 2c5:	5b                   	pop    %ebx
 2c6:	5d                   	pop    %ebp
 2c7:	c3                   	ret    
 2c8:	90                   	nop
 2c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000002d0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2d0:	55                   	push   %ebp
 2d1:	89 e5                	mov    %esp,%ebp
 2d3:	56                   	push   %esi
 2d4:	53                   	push   %ebx
 2d5:	8b 5d 10             	mov    0x10(%ebp),%ebx
 2d8:	8b 45 08             	mov    0x8(%ebp),%eax
 2db:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2de:	85 db                	test   %ebx,%ebx
 2e0:	7e 14                	jle    2f6 <memmove+0x26>
 2e2:	31 d2                	xor    %edx,%edx
 2e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 2e8:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 2ec:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 2ef:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
 2f2:	39 d3                	cmp    %edx,%ebx
 2f4:	75 f2                	jne    2e8 <memmove+0x18>
  return vdst;
}
 2f6:	5b                   	pop    %ebx
 2f7:	5e                   	pop    %esi
 2f8:	5d                   	pop    %ebp
 2f9:	c3                   	ret    

000002fa <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2fa:	b8 01 00 00 00       	mov    $0x1,%eax
 2ff:	cd 40                	int    $0x40
 301:	c3                   	ret    

00000302 <exit>:
SYSCALL(exit)
 302:	b8 02 00 00 00       	mov    $0x2,%eax
 307:	cd 40                	int    $0x40
 309:	c3                   	ret    

0000030a <wait>:
SYSCALL(wait)
 30a:	b8 03 00 00 00       	mov    $0x3,%eax
 30f:	cd 40                	int    $0x40
 311:	c3                   	ret    

00000312 <pipe>:
SYSCALL(pipe)
 312:	b8 04 00 00 00       	mov    $0x4,%eax
 317:	cd 40                	int    $0x40
 319:	c3                   	ret    

0000031a <read>:
SYSCALL(read)
 31a:	b8 05 00 00 00       	mov    $0x5,%eax
 31f:	cd 40                	int    $0x40
 321:	c3                   	ret    

00000322 <write>:
SYSCALL(write)
 322:	b8 10 00 00 00       	mov    $0x10,%eax
 327:	cd 40                	int    $0x40
 329:	c3                   	ret    

0000032a <close>:
SYSCALL(close)
 32a:	b8 15 00 00 00       	mov    $0x15,%eax
 32f:	cd 40                	int    $0x40
 331:	c3                   	ret    

00000332 <kill>:
SYSCALL(kill)
 332:	b8 06 00 00 00       	mov    $0x6,%eax
 337:	cd 40                	int    $0x40
 339:	c3                   	ret    

0000033a <exec>:
SYSCALL(exec)
 33a:	b8 07 00 00 00       	mov    $0x7,%eax
 33f:	cd 40                	int    $0x40
 341:	c3                   	ret    

00000342 <open>:
SYSCALL(open)
 342:	b8 0f 00 00 00       	mov    $0xf,%eax
 347:	cd 40                	int    $0x40
 349:	c3                   	ret    

0000034a <mknod>:
SYSCALL(mknod)
 34a:	b8 11 00 00 00       	mov    $0x11,%eax
 34f:	cd 40                	int    $0x40
 351:	c3                   	ret    

00000352 <unlink>:
SYSCALL(unlink)
 352:	b8 12 00 00 00       	mov    $0x12,%eax
 357:	cd 40                	int    $0x40
 359:	c3                   	ret    

0000035a <fstat>:
SYSCALL(fstat)
 35a:	b8 08 00 00 00       	mov    $0x8,%eax
 35f:	cd 40                	int    $0x40
 361:	c3                   	ret    

00000362 <link>:
SYSCALL(link)
 362:	b8 13 00 00 00       	mov    $0x13,%eax
 367:	cd 40                	int    $0x40
 369:	c3                   	ret    

0000036a <mkdir>:
SYSCALL(mkdir)
 36a:	b8 14 00 00 00       	mov    $0x14,%eax
 36f:	cd 40                	int    $0x40
 371:	c3                   	ret    

00000372 <chdir>:
SYSCALL(chdir)
 372:	b8 09 00 00 00       	mov    $0x9,%eax
 377:	cd 40                	int    $0x40
 379:	c3                   	ret    

0000037a <dup>:
SYSCALL(dup)
 37a:	b8 0a 00 00 00       	mov    $0xa,%eax
 37f:	cd 40                	int    $0x40
 381:	c3                   	ret    

00000382 <getpid>:
SYSCALL(getpid)
 382:	b8 0b 00 00 00       	mov    $0xb,%eax
 387:	cd 40                	int    $0x40
 389:	c3                   	ret    

0000038a <sbrk>:
SYSCALL(sbrk)
 38a:	b8 0c 00 00 00       	mov    $0xc,%eax
 38f:	cd 40                	int    $0x40
 391:	c3                   	ret    

00000392 <sleep>:
SYSCALL(sleep)
 392:	b8 0d 00 00 00       	mov    $0xd,%eax
 397:	cd 40                	int    $0x40
 399:	c3                   	ret    

0000039a <uptime>:
SYSCALL(uptime)
 39a:	b8 0e 00 00 00       	mov    $0xe,%eax
 39f:	cd 40                	int    $0x40
 3a1:	c3                   	ret    

000003a2 <waitx>:
SYSCALL(waitx)
 3a2:	b8 16 00 00 00       	mov    $0x16,%eax
 3a7:	cd 40                	int    $0x40
 3a9:	c3                   	ret    

000003aa <getpinfo>:
SYSCALL(getpinfo)
 3aa:	b8 17 00 00 00       	mov    $0x17,%eax
 3af:	cd 40                	int    $0x40
 3b1:	c3                   	ret    

000003b2 <ps>:
SYSCALL(ps)
 3b2:	b8 18 00 00 00       	mov    $0x18,%eax
 3b7:	cd 40                	int    $0x40
 3b9:	c3                   	ret    

000003ba <set_priority>:
SYSCALL(set_priority)
 3ba:	b8 19 00 00 00       	mov    $0x19,%eax
 3bf:	cd 40                	int    $0x40
 3c1:	c3                   	ret    
 3c2:	66 90                	xchg   %ax,%ax
 3c4:	66 90                	xchg   %ax,%ax
 3c6:	66 90                	xchg   %ax,%ax
 3c8:	66 90                	xchg   %ax,%ax
 3ca:	66 90                	xchg   %ax,%ax
 3cc:	66 90                	xchg   %ax,%ax
 3ce:	66 90                	xchg   %ax,%ax

000003d0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 3d0:	55                   	push   %ebp
 3d1:	89 e5                	mov    %esp,%ebp
 3d3:	57                   	push   %edi
 3d4:	56                   	push   %esi
 3d5:	53                   	push   %ebx
 3d6:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3d9:	85 d2                	test   %edx,%edx
{
 3db:	89 45 c0             	mov    %eax,-0x40(%ebp)
    neg = 1;
    x = -xx;
 3de:	89 d0                	mov    %edx,%eax
  if(sgn && xx < 0){
 3e0:	79 76                	jns    458 <printint+0x88>
 3e2:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 3e6:	74 70                	je     458 <printint+0x88>
    x = -xx;
 3e8:	f7 d8                	neg    %eax
    neg = 1;
 3ea:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 3f1:	31 f6                	xor    %esi,%esi
 3f3:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 3f6:	eb 0a                	jmp    402 <printint+0x32>
 3f8:	90                   	nop
 3f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  do{
    buf[i++] = digits[x % base];
 400:	89 fe                	mov    %edi,%esi
 402:	31 d2                	xor    %edx,%edx
 404:	8d 7e 01             	lea    0x1(%esi),%edi
 407:	f7 f1                	div    %ecx
 409:	0f b6 92 08 08 00 00 	movzbl 0x808(%edx),%edx
  }while((x /= base) != 0);
 410:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
 412:	88 14 3b             	mov    %dl,(%ebx,%edi,1)
  }while((x /= base) != 0);
 415:	75 e9                	jne    400 <printint+0x30>
  if(neg)
 417:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 41a:	85 c0                	test   %eax,%eax
 41c:	74 08                	je     426 <printint+0x56>
    buf[i++] = '-';
 41e:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
 423:	8d 7e 02             	lea    0x2(%esi),%edi
 426:	8d 74 3d d7          	lea    -0x29(%ebp,%edi,1),%esi
 42a:	8b 7d c0             	mov    -0x40(%ebp),%edi
 42d:	8d 76 00             	lea    0x0(%esi),%esi
 430:	0f b6 06             	movzbl (%esi),%eax
  write(fd, &c, 1);
 433:	83 ec 04             	sub    $0x4,%esp
 436:	83 ee 01             	sub    $0x1,%esi
 439:	6a 01                	push   $0x1
 43b:	53                   	push   %ebx
 43c:	57                   	push   %edi
 43d:	88 45 d7             	mov    %al,-0x29(%ebp)
 440:	e8 dd fe ff ff       	call   322 <write>

  while(--i >= 0)
 445:	83 c4 10             	add    $0x10,%esp
 448:	39 de                	cmp    %ebx,%esi
 44a:	75 e4                	jne    430 <printint+0x60>
    putc(fd, buf[i]);
}
 44c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 44f:	5b                   	pop    %ebx
 450:	5e                   	pop    %esi
 451:	5f                   	pop    %edi
 452:	5d                   	pop    %ebp
 453:	c3                   	ret    
 454:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 458:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 45f:	eb 90                	jmp    3f1 <printint+0x21>
 461:	eb 0d                	jmp    470 <printf>
 463:	90                   	nop
 464:	90                   	nop
 465:	90                   	nop
 466:	90                   	nop
 467:	90                   	nop
 468:	90                   	nop
 469:	90                   	nop
 46a:	90                   	nop
 46b:	90                   	nop
 46c:	90                   	nop
 46d:	90                   	nop
 46e:	90                   	nop
 46f:	90                   	nop

00000470 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 470:	55                   	push   %ebp
 471:	89 e5                	mov    %esp,%ebp
 473:	57                   	push   %edi
 474:	56                   	push   %esi
 475:	53                   	push   %ebx
 476:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 479:	8b 75 0c             	mov    0xc(%ebp),%esi
 47c:	0f b6 1e             	movzbl (%esi),%ebx
 47f:	84 db                	test   %bl,%bl
 481:	0f 84 b3 00 00 00    	je     53a <printf+0xca>
  ap = (uint*)(void*)&fmt + 1;
 487:	8d 45 10             	lea    0x10(%ebp),%eax
 48a:	83 c6 01             	add    $0x1,%esi
  state = 0;
 48d:	31 ff                	xor    %edi,%edi
  ap = (uint*)(void*)&fmt + 1;
 48f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 492:	eb 2f                	jmp    4c3 <printf+0x53>
 494:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 498:	83 f8 25             	cmp    $0x25,%eax
 49b:	0f 84 a7 00 00 00    	je     548 <printf+0xd8>
  write(fd, &c, 1);
 4a1:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 4a4:	83 ec 04             	sub    $0x4,%esp
 4a7:	88 5d e2             	mov    %bl,-0x1e(%ebp)
 4aa:	6a 01                	push   $0x1
 4ac:	50                   	push   %eax
 4ad:	ff 75 08             	pushl  0x8(%ebp)
 4b0:	e8 6d fe ff ff       	call   322 <write>
 4b5:	83 c4 10             	add    $0x10,%esp
 4b8:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
 4bb:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 4bf:	84 db                	test   %bl,%bl
 4c1:	74 77                	je     53a <printf+0xca>
    if(state == 0){
 4c3:	85 ff                	test   %edi,%edi
    c = fmt[i] & 0xff;
 4c5:	0f be cb             	movsbl %bl,%ecx
 4c8:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 4cb:	74 cb                	je     498 <printf+0x28>
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4cd:	83 ff 25             	cmp    $0x25,%edi
 4d0:	75 e6                	jne    4b8 <printf+0x48>
      if(c == 'd'){
 4d2:	83 f8 64             	cmp    $0x64,%eax
 4d5:	0f 84 05 01 00 00    	je     5e0 <printf+0x170>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 4db:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 4e1:	83 f9 70             	cmp    $0x70,%ecx
 4e4:	74 72                	je     558 <printf+0xe8>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 4e6:	83 f8 73             	cmp    $0x73,%eax
 4e9:	0f 84 99 00 00 00    	je     588 <printf+0x118>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 4ef:	83 f8 63             	cmp    $0x63,%eax
 4f2:	0f 84 08 01 00 00    	je     600 <printf+0x190>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 4f8:	83 f8 25             	cmp    $0x25,%eax
 4fb:	0f 84 ef 00 00 00    	je     5f0 <printf+0x180>
  write(fd, &c, 1);
 501:	8d 45 e7             	lea    -0x19(%ebp),%eax
 504:	83 ec 04             	sub    $0x4,%esp
 507:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 50b:	6a 01                	push   $0x1
 50d:	50                   	push   %eax
 50e:	ff 75 08             	pushl  0x8(%ebp)
 511:	e8 0c fe ff ff       	call   322 <write>
 516:	83 c4 0c             	add    $0xc,%esp
 519:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 51c:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 51f:	6a 01                	push   $0x1
 521:	50                   	push   %eax
 522:	ff 75 08             	pushl  0x8(%ebp)
 525:	83 c6 01             	add    $0x1,%esi
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 528:	31 ff                	xor    %edi,%edi
  write(fd, &c, 1);
 52a:	e8 f3 fd ff ff       	call   322 <write>
  for(i = 0; fmt[i]; i++){
 52f:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
  write(fd, &c, 1);
 533:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 536:	84 db                	test   %bl,%bl
 538:	75 89                	jne    4c3 <printf+0x53>
    }
  }
}
 53a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 53d:	5b                   	pop    %ebx
 53e:	5e                   	pop    %esi
 53f:	5f                   	pop    %edi
 540:	5d                   	pop    %ebp
 541:	c3                   	ret    
 542:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        state = '%';
 548:	bf 25 00 00 00       	mov    $0x25,%edi
 54d:	e9 66 ff ff ff       	jmp    4b8 <printf+0x48>
 552:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 558:	83 ec 0c             	sub    $0xc,%esp
 55b:	b9 10 00 00 00       	mov    $0x10,%ecx
 560:	6a 00                	push   $0x0
 562:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 565:	8b 45 08             	mov    0x8(%ebp),%eax
 568:	8b 17                	mov    (%edi),%edx
 56a:	e8 61 fe ff ff       	call   3d0 <printint>
        ap++;
 56f:	89 f8                	mov    %edi,%eax
 571:	83 c4 10             	add    $0x10,%esp
      state = 0;
 574:	31 ff                	xor    %edi,%edi
        ap++;
 576:	83 c0 04             	add    $0x4,%eax
 579:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 57c:	e9 37 ff ff ff       	jmp    4b8 <printf+0x48>
 581:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 588:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 58b:	8b 08                	mov    (%eax),%ecx
        ap++;
 58d:	83 c0 04             	add    $0x4,%eax
 590:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        if(s == 0)
 593:	85 c9                	test   %ecx,%ecx
 595:	0f 84 8e 00 00 00    	je     629 <printf+0x1b9>
        while(*s != 0){
 59b:	0f b6 01             	movzbl (%ecx),%eax
      state = 0;
 59e:	31 ff                	xor    %edi,%edi
        s = (char*)*ap;
 5a0:	89 cb                	mov    %ecx,%ebx
        while(*s != 0){
 5a2:	84 c0                	test   %al,%al
 5a4:	0f 84 0e ff ff ff    	je     4b8 <printf+0x48>
 5aa:	89 75 d0             	mov    %esi,-0x30(%ebp)
 5ad:	89 de                	mov    %ebx,%esi
 5af:	8b 5d 08             	mov    0x8(%ebp),%ebx
 5b2:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 5b5:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 5b8:	83 ec 04             	sub    $0x4,%esp
          s++;
 5bb:	83 c6 01             	add    $0x1,%esi
 5be:	88 45 e3             	mov    %al,-0x1d(%ebp)
  write(fd, &c, 1);
 5c1:	6a 01                	push   $0x1
 5c3:	57                   	push   %edi
 5c4:	53                   	push   %ebx
 5c5:	e8 58 fd ff ff       	call   322 <write>
        while(*s != 0){
 5ca:	0f b6 06             	movzbl (%esi),%eax
 5cd:	83 c4 10             	add    $0x10,%esp
 5d0:	84 c0                	test   %al,%al
 5d2:	75 e4                	jne    5b8 <printf+0x148>
 5d4:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
 5d7:	31 ff                	xor    %edi,%edi
 5d9:	e9 da fe ff ff       	jmp    4b8 <printf+0x48>
 5de:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 10, 1);
 5e0:	83 ec 0c             	sub    $0xc,%esp
 5e3:	b9 0a 00 00 00       	mov    $0xa,%ecx
 5e8:	6a 01                	push   $0x1
 5ea:	e9 73 ff ff ff       	jmp    562 <printf+0xf2>
 5ef:	90                   	nop
  write(fd, &c, 1);
 5f0:	83 ec 04             	sub    $0x4,%esp
 5f3:	88 5d e5             	mov    %bl,-0x1b(%ebp)
 5f6:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 5f9:	6a 01                	push   $0x1
 5fb:	e9 21 ff ff ff       	jmp    521 <printf+0xb1>
        putc(fd, *ap);
 600:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  write(fd, &c, 1);
 603:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 606:	8b 07                	mov    (%edi),%eax
  write(fd, &c, 1);
 608:	6a 01                	push   $0x1
        ap++;
 60a:	83 c7 04             	add    $0x4,%edi
        putc(fd, *ap);
 60d:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 610:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 613:	50                   	push   %eax
 614:	ff 75 08             	pushl  0x8(%ebp)
 617:	e8 06 fd ff ff       	call   322 <write>
        ap++;
 61c:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 61f:	83 c4 10             	add    $0x10,%esp
      state = 0;
 622:	31 ff                	xor    %edi,%edi
 624:	e9 8f fe ff ff       	jmp    4b8 <printf+0x48>
          s = "(null)";
 629:	bb 00 08 00 00       	mov    $0x800,%ebx
        while(*s != 0){
 62e:	b8 28 00 00 00       	mov    $0x28,%eax
 633:	e9 72 ff ff ff       	jmp    5aa <printf+0x13a>
 638:	66 90                	xchg   %ax,%ax
 63a:	66 90                	xchg   %ax,%ax
 63c:	66 90                	xchg   %ax,%ax
 63e:	66 90                	xchg   %ax,%ax

00000640 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 640:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 641:	a1 b8 0a 00 00       	mov    0xab8,%eax
{
 646:	89 e5                	mov    %esp,%ebp
 648:	57                   	push   %edi
 649:	56                   	push   %esi
 64a:	53                   	push   %ebx
 64b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 64e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
 651:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 658:	39 c8                	cmp    %ecx,%eax
 65a:	8b 10                	mov    (%eax),%edx
 65c:	73 32                	jae    690 <free+0x50>
 65e:	39 d1                	cmp    %edx,%ecx
 660:	72 04                	jb     666 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 662:	39 d0                	cmp    %edx,%eax
 664:	72 32                	jb     698 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
 666:	8b 73 fc             	mov    -0x4(%ebx),%esi
 669:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 66c:	39 fa                	cmp    %edi,%edx
 66e:	74 30                	je     6a0 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 670:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 673:	8b 50 04             	mov    0x4(%eax),%edx
 676:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 679:	39 f1                	cmp    %esi,%ecx
 67b:	74 3a                	je     6b7 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 67d:	89 08                	mov    %ecx,(%eax)
  freep = p;
 67f:	a3 b8 0a 00 00       	mov    %eax,0xab8
}
 684:	5b                   	pop    %ebx
 685:	5e                   	pop    %esi
 686:	5f                   	pop    %edi
 687:	5d                   	pop    %ebp
 688:	c3                   	ret    
 689:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 690:	39 d0                	cmp    %edx,%eax
 692:	72 04                	jb     698 <free+0x58>
 694:	39 d1                	cmp    %edx,%ecx
 696:	72 ce                	jb     666 <free+0x26>
{
 698:	89 d0                	mov    %edx,%eax
 69a:	eb bc                	jmp    658 <free+0x18>
 69c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 6a0:	03 72 04             	add    0x4(%edx),%esi
 6a3:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 6a6:	8b 10                	mov    (%eax),%edx
 6a8:	8b 12                	mov    (%edx),%edx
 6aa:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 6ad:	8b 50 04             	mov    0x4(%eax),%edx
 6b0:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 6b3:	39 f1                	cmp    %esi,%ecx
 6b5:	75 c6                	jne    67d <free+0x3d>
    p->s.size += bp->s.size;
 6b7:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 6ba:	a3 b8 0a 00 00       	mov    %eax,0xab8
    p->s.size += bp->s.size;
 6bf:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6c2:	8b 53 f8             	mov    -0x8(%ebx),%edx
 6c5:	89 10                	mov    %edx,(%eax)
}
 6c7:	5b                   	pop    %ebx
 6c8:	5e                   	pop    %esi
 6c9:	5f                   	pop    %edi
 6ca:	5d                   	pop    %ebp
 6cb:	c3                   	ret    
 6cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000006d0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 6d0:	55                   	push   %ebp
 6d1:	89 e5                	mov    %esp,%ebp
 6d3:	57                   	push   %edi
 6d4:	56                   	push   %esi
 6d5:	53                   	push   %ebx
 6d6:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6d9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 6dc:	8b 15 b8 0a 00 00    	mov    0xab8,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6e2:	8d 78 07             	lea    0x7(%eax),%edi
 6e5:	c1 ef 03             	shr    $0x3,%edi
 6e8:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 6eb:	85 d2                	test   %edx,%edx
 6ed:	0f 84 9d 00 00 00    	je     790 <malloc+0xc0>
 6f3:	8b 02                	mov    (%edx),%eax
 6f5:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 6f8:	39 cf                	cmp    %ecx,%edi
 6fa:	76 6c                	jbe    768 <malloc+0x98>
 6fc:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 702:	bb 00 10 00 00       	mov    $0x1000,%ebx
 707:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 70a:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 711:	eb 0e                	jmp    721 <malloc+0x51>
 713:	90                   	nop
 714:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 718:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 71a:	8b 48 04             	mov    0x4(%eax),%ecx
 71d:	39 f9                	cmp    %edi,%ecx
 71f:	73 47                	jae    768 <malloc+0x98>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 721:	39 05 b8 0a 00 00    	cmp    %eax,0xab8
 727:	89 c2                	mov    %eax,%edx
 729:	75 ed                	jne    718 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
 72b:	83 ec 0c             	sub    $0xc,%esp
 72e:	56                   	push   %esi
 72f:	e8 56 fc ff ff       	call   38a <sbrk>
  if(p == (char*)-1)
 734:	83 c4 10             	add    $0x10,%esp
 737:	83 f8 ff             	cmp    $0xffffffff,%eax
 73a:	74 1c                	je     758 <malloc+0x88>
  hp->s.size = nu;
 73c:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 73f:	83 ec 0c             	sub    $0xc,%esp
 742:	83 c0 08             	add    $0x8,%eax
 745:	50                   	push   %eax
 746:	e8 f5 fe ff ff       	call   640 <free>
  return freep;
 74b:	8b 15 b8 0a 00 00    	mov    0xab8,%edx
      if((p = morecore(nunits)) == 0)
 751:	83 c4 10             	add    $0x10,%esp
 754:	85 d2                	test   %edx,%edx
 756:	75 c0                	jne    718 <malloc+0x48>
        return 0;
  }
}
 758:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 75b:	31 c0                	xor    %eax,%eax
}
 75d:	5b                   	pop    %ebx
 75e:	5e                   	pop    %esi
 75f:	5f                   	pop    %edi
 760:	5d                   	pop    %ebp
 761:	c3                   	ret    
 762:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 768:	39 cf                	cmp    %ecx,%edi
 76a:	74 54                	je     7c0 <malloc+0xf0>
        p->s.size -= nunits;
 76c:	29 f9                	sub    %edi,%ecx
 76e:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 771:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 774:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 777:	89 15 b8 0a 00 00    	mov    %edx,0xab8
}
 77d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 780:	83 c0 08             	add    $0x8,%eax
}
 783:	5b                   	pop    %ebx
 784:	5e                   	pop    %esi
 785:	5f                   	pop    %edi
 786:	5d                   	pop    %ebp
 787:	c3                   	ret    
 788:	90                   	nop
 789:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    base.s.ptr = freep = prevp = &base;
 790:	c7 05 b8 0a 00 00 bc 	movl   $0xabc,0xab8
 797:	0a 00 00 
 79a:	c7 05 bc 0a 00 00 bc 	movl   $0xabc,0xabc
 7a1:	0a 00 00 
    base.s.size = 0;
 7a4:	b8 bc 0a 00 00       	mov    $0xabc,%eax
 7a9:	c7 05 c0 0a 00 00 00 	movl   $0x0,0xac0
 7b0:	00 00 00 
 7b3:	e9 44 ff ff ff       	jmp    6fc <malloc+0x2c>
 7b8:	90                   	nop
 7b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        prevp->s.ptr = p->s.ptr;
 7c0:	8b 08                	mov    (%eax),%ecx
 7c2:	89 0a                	mov    %ecx,(%edx)
 7c4:	eb b1                	jmp    777 <malloc+0xa7>
