function [Ex1,Ey1,Ez1]=Diffraction2DTransPolar1(Ex0,Ey0,Z,Wavelen0,n_refr,Dx,N,nn)
     num=0:N-1;
%      nn=50;%显示区域范围
     freq=1./(N*Dx)*(num-N/2+0.5);
     freq_x=freq'*ones(1,N);% 注意：所有矩阵的水平方向为Y，竖直方向为X
     freq_y=freq_x'; %freq_x  注意：所有矩阵的水平方向为Y，竖直方向为X
     fz=sqrt((n_refr/Wavelen0).^2-freq_x.^2-freq_y.^2);
     [Ex]=FourrierTrans2D1(Ex0, Dx, N, 1);
     [Ey]=FourrierTrans2D1(Ey0, Dx, N, 1);
%      clear Ex0 Ey0;
     Ez=-(freq_x.*Ex+freq_y.*Ey)./fz.*exp(1i*2*pi*fz*Z);
     %freq_y  注意：所有矩阵的水平方向为Y，竖直方向为X
%      Ez=zeros(N,N);
     Ez=FourrierTrans2D1(Ez, Dx, N, -1);  
%      clear SpectrumZ; 
     Ez1=Ez((N/2-nn:N/2+1+nn),(N/2-nn:N/2+1+nn));
     clear Ez;   
     Ex=Ex.*exp(i*2*pi*fz*Z);
%      Ex=zeros(N,N);
     Ex=FourrierTrans2D1(Ex, Dx, N, -1);
     clear SpectrumX ;
     Ex1=Ex((N/2-nn:N/2+1+nn),(N/2-nn:N/2+1+nn));
     clear Ex;
     Ey=Ey.*exp(i*2*pi*fz*Z);                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
%      Ey=zeros(N,N);
     Ey=FourrierTrans2D1(Ey, Dx, N, -1); 
     clear SpectrumY;
     Ey1=Ey((N/2-nn:N/2+1+nn),(N/2-nn:N/2+1+nn));
     clear Ey;
     
end