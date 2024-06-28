function [G]=FourrierTrans2D1(g, Dx, N, flag)
   num=0:N-1;
   a=exp(1i*2*pi/N*(N/2-0.5)*num);
   A=a.'*a;
   C=exp(-1i*2*pi/N*(N/2-0.5).^2*2)*A; 
   if flag==1             
      G=Dx.^2.*C.*fft2(A.*g); %����Ҫ����λ������������
   end
   if flag==-1
      G=(1./(N*Dx)).^2.*N^2*conj(C).*ifft2(conj(A).*g);
   end
   
%    G=[G(2:N,:); G(1,:)];%�޲� û�����������(Ϊʲô����Ҷ�任����λ)07-01-2018�д��ҵ�ԭ��,�����Ƶ���ʽ�������ǲ����Ƶ������󣬻��о��Ǳ�������ǰ������Ƿ�����
end