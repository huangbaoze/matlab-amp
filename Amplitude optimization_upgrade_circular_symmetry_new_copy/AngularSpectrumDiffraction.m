function [ratio1,distance1,strength1]=AngularSpectrumDiffraction(ExSet,EySet,wavelenNum,N)

n_refra=1; %出射场所在空间的折射率
T=46.4;
Dx=T/10;%采样间隔
wavelen0=74;%um
load('wavelen.mat','wavelen');
M=2*N+1;%纵横坐标点数
mm=10*M;%每个周期划分10x10

nn=250;
Num=51;
if wavelenNum==1
    Zd1=(357:0.2:367)*wavelen0;%优化第1波长
end
if wavelenNum==15
    Zd1=(324:0.2:334)*wavelen0;%优化第15波长
end
if wavelenNum==8
    Zd1=(339:0.2:349)*wavelen0;%优化第8波长
end
if wavelenNum==28
    Zd1=(287:0.2:297)*wavelen0;%优化第28波长
end
if wavelenNum==19
    Zd1=(310:0.2:320)*wavelen0;%优化第19波长
end
if wavelenNum==10
    Zd1=(337:0.2:347)*wavelen0;%优化第10波长
end
if wavelenNum==22
    Zd1=(303:0.2:313)*wavelen0;%优化第22波长
end
for nnz=1:Num  
    nnz
    %Zd1=(269:0.2:374)*wavelen0;
    %Zd1=(350:0.2:374)*wavelen0;%优化第1波长
    %Zd1=(343:0.2:353)*wavelen0;%优化第7波长
    tic
    [Ex1,Ey1,Ez1]=Diffraction2DTransPolar1(ExSet,EySet,Zd1(nnz),wavelen(wavelenNum),n_refra,Dx,mm,nn);%衍射计算，计算波长wavelen0
    toc
    ItotalDisplay=abs(Ex1).^2+abs(Ey1).^2+abs(Ez1).^2;%没有旋转因子,总场不需要旋转
    ZItotalDisplay(:,nnz)=ItotalDisplay(:,nn+1);
end

[ratio1,distance1,strength1]=computing_plot(Zd1,ZItotalDisplay,wavelenNum,Num);%%显示传播z方向强度图
clear Zd1;
