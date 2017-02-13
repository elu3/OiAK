.data
.bss
.comm textin, 512
.comm textout, 512
.global myadd
.global Q_rsqrtf
.text

myadd:
mov    %rsi, %rax
add    %rdi, %rax
retq


Q_rsqrtf:
 movss  %xmm0,-0xc(%rsp)
 mov    -0xc(%rsp),%rdx
 mov    $0x5f3759df,%eax
 movw    $0x00003f,-0xc(%rsp) 
 movss  -0xc(%rsp),%xmm1      
 nop
 mulss  %xmm0,%xmm1
 movw    $0x0000c03f, -0xc(%rsp)
 movss  -0xc(%rsp),%xmm0       
 nop 
 sar    %rdx
 sub    %rdx,%rax
 mov    %rax,-0x8(%rsp)
 movss  -0x8(%rsp),%xmm2
 mulss  %xmm2,%xmm1
 mulss  %xmm2,%xmm1
 subss  %xmm1,%xmm0
 mulss  %xmm2,%xmm0
 retq