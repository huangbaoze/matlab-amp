function AngularSpectrumDiffraction(ExSet,EySet,wavelenNum,N)

n_refra=1; %出射场所在空间的折射率
T=46.4;
Dx=T/10;%24;%采样间隔
wavelen0=74;%um
load('wavelen.mat','wavelen');
Zrange=20*wavelen0;%计算的范围（focallength-0.5Zrang,focallength+0.5Z）
Nz=50;%计算焦平面前后2*Nz+1个平面内的光场(Nz==0时，只计算焦平面上的光场
M=2*N+1;%纵横坐标点数
mm=10*M;%每个周期划分24x24
%--计算衍射场---------------------------
dZ=Zrange/(Nz*2);
load('f.mat','f');
Zd=f(wavelenNum)+dZ*(-Nz);
for k=(-Nz+1):Nz
    Zd=[Zd f(wavelenNum)+dZ*k];
end

nn=250;
Num=1251;
for nnz=1:Num%2*Nz+1   
    nnz
%     Zd1=(250:0.2:400)*wavelen0;
    Zd1=(150:0.2:400)*wavelen0;
    tic
    [Ex1,Ey1,Ez1]=Diffraction2DTransPolar1(ExSet,EySet,Zd1(nnz),wavelen(wavelenNum),n_refra,Dx,mm,nn);%衍射计算，计算波长wavelen0
    toc

    ItotalDisplay=abs(Ex1).^2+abs(Ey1).^2+abs(Ez1).^2;%没有旋转因子,总场不需要旋转
%     if nnz==Nz+1
%     AllDisplay_plot(wavelenNum,ItotalDisplay);%%%显示焦平面xy聚焦图
%     end
           
    ZItotalDisplay(:,nnz)=ItotalDisplay(:,nn+1);
end
global PathName;global PathName3;
Zfilename=strcat('ZItotalDisplay',num2str(wavelenNum),'.xlsx');
cd(PathName3);
xlswrite(Zfilename,ZItotalDisplay,1,'A1');
cd(PathName);
computing_plot(Zd1,ZItotalDisplay,wavelenNum,Num);%%显示传播z方向强度图
clear Zd1;
