clc
clear
close all;
N=182;
a=46.4*(N-1)+23.2;
R=sqrt(2)*a;%透镜半径   理想设计是200*wavelen0
t=R/74;%中心设计波长是74um
load('f0.mat','f');
for wavelenNum=1:37
NA=sin(atan(R/f(wavelenNum)));%数值孔径
DLWavelen(wavelenNum)=0.5/NA;%衍射极限*设计波长
end