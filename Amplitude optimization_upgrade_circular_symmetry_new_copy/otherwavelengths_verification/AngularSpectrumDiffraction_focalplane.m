function AngularSpectrumDiffraction_focalplane(ExSet,EySet,wavelenNum,N)

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

global PathName0;
ranges=xlsread(strcat(PathName0,'\DL_FWHM_f_FL_Ipeak1.xlsx'),1,'D1:D37');
nn=250;
n1=2*nn+2;

tic
[Ex1,Ey1,Ez1]=Diffraction2DTransPolar1(ExSet,EySet,ranges(wavelenNum)*wavelen0,wavelen(wavelenNum),n_refra,Dx,mm,nn);%衍射计算，计算波长wavelen0
toc

ItotalDisplay_incident=abs(ExSet).^2+abs(EySet).^2;
ItotalDisplay=abs(Ex1).^2+abs(Ey1).^2+abs(Ez1).^2;%没有旋转因子,总场不需要旋转

global PathName3;
Zfilename=strcat('ItotalDisplay',num2str(wavelenNum),'.xlsx');
cd(PathName3);
xlswrite(Zfilename,ItotalDisplay_incident,1,'A1');
xlswrite(Zfilename,ItotalDisplay,2,'A1');
ItotalDisplay_incident_sum=sum(sum(ItotalDisplay_incident));%入射场强度总和

ItotalDisplay_horizontal=ItotalDisplay(n1/2,:);
fwhm_x=find(ItotalDisplay_horizontal>=max(max(ItotalDisplay))/2);
xx=fwhm_x(end)-n1/2;

[x,y]=find((ItotalDisplay/max(max(ItotalDisplay)))>=1/exp(1));
ItotalDisplay_sum=0;
for j=1:size(x)
    if sqrt((x(j)-n1/2)^2+(y(j)-n1/2)^2)>xx
        tmp=0;
    else
        tmp=ItotalDisplay(x(j),y(j));
    end
ItotalDisplay_sum=ItotalDisplay_sum+tmp;
end
xlswrite(Zfilename,[ItotalDisplay_incident_sum,ItotalDisplay_sum,ItotalDisplay_sum/ItotalDisplay_incident_sum],3,'A1');
global PathName;
cd(PathName);
