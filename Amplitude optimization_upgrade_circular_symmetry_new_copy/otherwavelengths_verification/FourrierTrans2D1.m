function [G]=FourrierTrans2D1(g, Dx, N, flag)
   num=0:N-1;
   a=exp(1i*2*pi/N*(N/2-0.5)*num);
   A=a.'*a;
   C=exp(-1i*2*pi/N*(N/2-0.5).^2*2)*A; 
   if flag==1             
      G=Dx.^2.*C.*fft2(A.*g); %不需要做错位修正？？？？
   end
   if flag==-1
      G=(1./(N*Dx)).^2.*N^2*conj(C).*ifft2(conj(A).*g);
   end
   
%    G=[G(2:N,:); G(1,:)];%修补 没解决根本问题(为什么傅里叶变换后会错位)07-01-2018尚待找到原因,根据推到公式，看看是不是推到中有误，还有就是本函数中前面代码是否有误
end