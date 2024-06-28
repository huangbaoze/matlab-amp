clc
clear
C=2.99792458*10^14/1e12;% um/ps 光速
wavelen_min=68;%um %最小波长
wavelen0=74;%um 中心设计波长
wavelen_max=80;%um %最大波长
wavelen=[wavelen_min:1/3:wavelen_max];
w0=2*pi*C/wavelen0; %中心（角）频率 rad/ps
for i=1:37
w(i)=2*pi*C/wavelen(i);
end
f0=315*wavelen0; %中心波长对应焦距
b0=3*f0/w0;%是线性近似的多少倍 um.ps/rad
f=f0+b0*(w-w0);%相位分布之焦距与频率设计公式
f1=f/wavelen0;
