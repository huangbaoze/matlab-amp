clc
clear
close all

filename='(54)_up_circle_gd_gdd_37_n=1';
pathname='E:\huangbaoze\matlab\Amplitude optimization_upgrade_circular_symmetry_new_copy\otherwavelengths_verification\';
matchingnum='matching_GD_GDD37';
xlswrite(strcat(pathname,filename,'\GD_GDD_matching.xlsx'),{matchingnum},1,'G1');
Num_L_W_A_P_beta=importdata('Num_L_W_A_P_betarad.xlsx',1);
N=155;
wavelen0=74;%um 中心波长
R=46.4*N+23.2;
f0=315*wavelen0; %中心波长对应焦距
save(strcat(pathname,filename,'\R.mat'),'R');
T=46.4;%um
save(strcat(pathname,filename,'\N.mat'),'N');
M=2*N+1;%纵横坐标点数
xx=-(N*T):T:N*T;
yy=N*T:-T:-(N*T);
X=zeros(M,M);
Y=zeros(M,M);
h=65.7;%thickness

for p=1:M
    X(p,:)=xx(p);
    Y(:,p)=yy(p);
end

rr=zeros(M,M);  %单元格子中心与结构中心(0,0)的距离
ss=zeros(M,M);  %单元格子中心与焦点的距离
GeneNum=zeros(M,M);%单元格子所对应的基因编号
phi=zeros(M,M);  %每个格子处的相位
amp=zeros(M,M);%每个格子处的相位处的振幅

k00=2*pi/wavelen0;
phi00=k00*f0;

[s,t]=size(Num_L_W_A_P_beta);
for i=1:M
    for j=1:M
       rr(i,j)=sqrt(X(i,j)^2+Y(i,j)^2);
       ss(i,j)=sqrt(rr(i,j)^2+f0^2);  
       phi(i,j)=phi00-k00*ss(i,j); 
       nn=phi(i,j)/(2*pi);
       nn=floor(nn);   
       if nn==0
           phi(i,j)=0;
       else
           phi(i,j)=phi(i,j)-nn*2*pi;
       end

     if  phi(i,j)>=Num_L_W_A_P_beta(16,5)
           if abs(2*pi-phi(i,j))<=abs(phi(i,j)-Num_L_W_A_P_beta(16,5))
               aa=1;
           else
               aa=16;
           end
     else
           for k=1:s-1
               if phi(i,j)<Num_L_W_A_P_beta(k+1,5)&&phi(i,j)>=Num_L_W_A_P_beta(k,5)
                   if abs(phi(i,j)-Num_L_W_A_P_beta(k,5))<=abs(phi(i,j)-Num_L_W_A_P_beta(k+1,5))
                       aa=k;
                   else
                       aa=k+1;
                   end                
               end
           end
     end
     phi(i,j)=Num_L_W_A_P_beta(aa,5);
     GeneNum(i,j)=Num_L_W_A_P_beta(aa,1);                
   end
end

for i=1:M
    for j=1:M
        BandNum(i,j)=floor(rr(i,j)/T)+1;
        if rr(i,j)>R%周期格子中心点距离圆点小于设定的半径R舍弃，相位为0，标记置为0
            phi(i,j)=0;
            GeneNum(i,j)=0;
            BandNum(i,j)=0;
        end
    end
end
save(strcat(pathname,filename,'\phi.mat'),'phi');
save(strcat(pathname,filename,'\GeneNum.mat'),'GeneNum');
save(strcat(pathname,filename,'\BandNum.mat'),'BandNum');
%随机选择环带结构
% for bandnum=1:N+1
% file=strcat('E:\huangbaoze\matlab\Start_HyperbolicLens\',matchingnum,'\Lx_Ly_GD_GDD_rmse_A',num2str(N+2-bandnum),'.xlsx');
% datatmp0=xlsread(file,2);
% datatmp=datatmp0(:,19);
% [H,~]=size(datatmp);
% band(bandnum)=datatmp(randi([1,H]));
% end

%固定选择一个结构，不做色散调控处理
for bandnum=1:N+1
band(bandnum)=0.360911401;
end

xlswrite(strcat(pathname,filename,'\min_band.xlsx'),band,1);




