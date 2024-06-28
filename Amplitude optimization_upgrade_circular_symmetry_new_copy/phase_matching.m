%%%%%%%%%%%%%%unit um%%%%%%导入数据为rad%%rotation %%%%%%%%%%
close all
clear 
clc
tic

FileName='\(54)_up_circle_28_19_10_discont_gd_gdd_35_1';
PathName='E:\huangbaoze\matlab\Amplitude optimization_upgrade_circular_symmetry_new_copy\otherwavelengths_verification';
PathName0=strcat(PathName,FileName);
PathName1=strcat(PathName0,'\min_band.xlsx');
PathName2=strcat(PathName0,'\min_Ratio.xlsx');
PathName3=strcat(PathName0,'\phi.mat');
PathName4=strcat(PathName0,'\N.mat');
PathName5=strcat(PathName0,'\R.mat');
PathName6=strcat(PathName0,'\GeneNum.mat');
PathName7=strcat(PathName0,'\BandNum.mat');
matchingnum='matching_GD_GDD35';
xlswrite(strcat(PathName0,'\GD_GDD_matching.xlsx'),{matchingnum},1,'G1');

Num_L_W_A_P_beta=importdata('Num_L_W_A_P_betarad.xlsx',1);
C=2.99792458*10^14/1e12;% um/ps 光速
wavelen0=74;%um 中心波长
wavelen_min=68;%um %最小波长
wavelen_max=80;%um %最大波长
w0=2*pi*C/wavelen0; %中心（角）频率 rad/ps
f0=315*wavelen0; %中心波长对应焦距
% R=113.806*wavelen0;%透镜半径   理想设计是200*wavelen0
N=155;
R=46.4*N+23.2;
NA=sin(atan(R/f0));%数值孔径
DL=0.5*wavelen0/NA;%衍射极限
%b0=3*f0/w0;%是线性近似的多少倍 um.ps/rad
%F=f0+b0*(w-w0);相位分布之焦距与频率设计公式
T=46.4;%um
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

save(PathName3,'phi');
save(PathName4,'N');
save(PathName5,'R');
save(PathName6,'GeneNum');
save(PathName7,'BandNum');
%超参数设置
PopulationAll=5;
for i=1:PopulationAll
v(:,i)=rand(N+1,1)/500-0.001;%-0.001~0.001
end
w=0.9;%原来为0.01
c1=2;
c2=3;

% c=0.6;%变异因子
% q=0.4;%变异概率
wmax=0.9;
wmin=0.4;  %动态调整w
% z=0.3;


lam1=10;
lam2=19;
lam3=28;
InitialFlag=0;%标志为1，启动给定初始化；为0，启动随机初始化

tic
%%%%%%%%%%%%%%%%%%%%%初始化匹配%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if InitialFlag==1
%给定初始化粒子
bandinit=xlsread(strcat(PathName,FileName,'\Initial_band.xlsx'),1);
band=bandinit';
end
%%%%%%%%%%%%%%%%%%%%%初始化匹配%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:N+1
    file=strcat('E:\huangbaoze\matlab\Start_HyperbolicLens\',matchingnum,'\Lx_Ly_GD_GDD_rmse_A',num2str(i),'.xlsx');
    bandA=xlsread(file,2);
    bandP=xlsread(file,3);
    tmpA1=bandA(:,lam1);
    tmpA2=bandA(:,lam2);
    tmpA3=bandA(:,lam3);
    tmpP1=bandP(:,lam1);
    tmpP2=bandP(:,lam2);
    tmpP3=bandP(:,lam3);

    %划定振幅优化实际范围
    bandminmax(1,N+2-i)=min(tmpA2);
    bandminmax(2,N+2-i)=max(tmpA2);

    %随机生成粒子
    H=size(tmpA2,1);
    for j=1:PopulationAll
        if InitialFlag==0
            numtmp=randi([1,H]);
            band(N+2-i,j)=tmpA2(numtmp);
            %lam2
            band2(N+2-i,j)=band(i,j);%这里应该是 band(N+2-i,j)，暂时先不改回，因为第0次迭代暂时也轮不到第2层，很快第1次迭代就会更新成正确的值
            PhaseBandGap2(N+2-i,j)=tmpP2(numtmp);
            %lam1
            band1(N+2-i,j)=tmpA1(numtmp);
            PhaseBandGap1(N+2-i,j)=tmpP1(numtmp);
            %lam3
            band3(N+2-i,j)=tmpA3(numtmp);
            PhaseBandGap3(N+2-i,j)=tmpP3(numtmp);
        else
%%%%%%%%%%%%%%%%%%%%%初始化匹配%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            matchinggap=abs(tmpA2-band(N+2-i,j));
            min_matchinggapdiff(N+2-i,j)=min(matchinggap);
            [matchingH,~]=find(matchinggap==min_matchinggapdiff(N+2-i,j));
            band(N+2-i,j)=tmpA2(matchingH(1));
            band2(N+2-i,j)=tmpA2(matchingH(1));
            PhaseBandGap2(N+2-i,j)=tmpP2(matchingH(1));
            band1(N+2-i,j)=tmpA1(matchingH(1));
            PhaseBandGap1(N+2-i,j)=tmpP1(matchingH(1));
            band3(N+2-i,j)=tmpA3(matchingH(1));
            PhaseBandGap3(N+2-i,j)=tmpP3(matchingH(1));
%%%%%%%%%%%%%%%%%%%%%初始化匹配%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
        end
    end

    %计数
    if i==1
         sizeboun(i)=H;
         bandAall(1:H,1)=tmpA1;
         bandAall(1:H,2)=tmpA2;
         bandAall(1:H,3)=tmpA3;
         bandPall(1:H,1)=tmpP1;
         bandPall(1:H,2)=tmpP2;
         bandPall(1:H,3)=tmpP3;
    else
         sizeboun(i)=H+sizeboun(i-1);
         bandAall(sizeboun(i-1)+1:sizeboun(i),1)=tmpA1;
         bandAall(sizeboun(i-1)+1:sizeboun(i),2)=tmpA2;
         bandAall(sizeboun(i-1)+1:sizeboun(i),3)=tmpA3;
         bandPall(sizeboun(i-1)+1:sizeboun(i),1)=tmpP1;
         bandPall(sizeboun(i-1)+1:sizeboun(i),2)=tmpP2;
         bandPall(sizeboun(i-1)+1:sizeboun(i),3)=tmpP3;
    end
end
%%%%%%%%%%%%%%%%%%%%%初始化匹配%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if InitialFlag==1
for num=1:PopulationAll
    figure(4)
    plot(1:N+1,min_matchinggapdiff(:,num),'.');
    title(num2str(num));
end
end
%%%%%%%%%%%%%%%%%%%%%初始化匹配%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
toc

for Iteration=0:400
for PopulationNum=1:PopulationAll
    if Iteration>0
         %p(Iteration)=q*(100-Iteration)/100;
         %w=w-(w-wmin)*z;
         w=wmax-(wmax-wmin)/(300^2)*(Iteration^2);
        v(:,PopulationNum)=w*v(:,PopulationNum)+c1*rand*(record_band(:,PopulationNum)-band(:,PopulationNum))+...
        c2*rand*(min_band-band(:,PopulationNum));
        band(:,PopulationNum)=band(:,PopulationNum)+v(:,PopulationNum);
        for i=1:N+1
            if abs(v(i,PopulationNum))>0.01
                if v(i,PopulationNum)>0
                    v(i,PopulationNum)=0.01;
                else
                    v(i,PopulationNum)=-0.01;
                end
            end
            if band(i,PopulationNum)<bandminmax(1,i)
                band(i,PopulationNum)=bandminmax(1,i);
            else 
                if band(i,PopulationNum)>bandminmax(2,i)
                    band(i,PopulationNum)=bandminmax(2,i);
                end
            end

        end
%         if rand<p(Iteration)          %突变
%         band(:,PopulationNum)=(min_band-band(:,PopulationNum))*c+band(:,PopulationNum);      
%         end
        tic
        for t=1:N+1
            if t==1
                matchingA2=bandAall(1:sizeboun(t),2);
                matchingP2=bandPall(1:sizeboun(t),2);
                matchingA1=bandAall(1:sizeboun(t),1);
                matchingP1=bandPall(1:sizeboun(t),1);
                matchingA3=bandAall(1:sizeboun(t),3);
                matchingP3=bandPall(1:sizeboun(t),3);
            else
                matchingA2=bandAall(sizeboun(t-1)+1:sizeboun(t),2);
                matchingP2=bandPall(sizeboun(t-1)+1:sizeboun(t),2);
                matchingA1=bandAall(sizeboun(t-1)+1:sizeboun(t),1);
                matchingP1=bandPall(sizeboun(t-1)+1:sizeboun(t),1);
                matchingA3=bandAall(sizeboun(t-1)+1:sizeboun(t),3);
                matchingP3=bandPall(sizeboun(t-1)+1:sizeboun(t),3);
            end

            matchinggap=abs(matchingA2-band(N+2-t,PopulationNum));
            min_matchinggap(N+2-t)=min(matchinggap);
            [matchingH,~]=find(matchinggap==min_matchinggap(N+2-t));
            band(N+2-t,PopulationNum)=matchingA2(matchingH(1));
            band2(N+2-t,PopulationNum)=matchingA2(matchingH(1));
            PhaseBandGap2(N+2-t,PopulationNum)=matchingP2(matchingH(1));
            band1(N+2-t,PopulationNum)=matchingA1(matchingH(1));
            PhaseBandGap1(N+2-t,PopulationNum)=matchingP1(matchingH(1));
            band3(N+2-t,PopulationNum)=matchingA3(matchingH(1));
            PhaseBandGap3(N+2-t,PopulationNum)=matchingP3(matchingH(1));
        end
        figure(4)
        plot(1:N+1,min_matchinggap,'.');
        title(num2str(PopulationNum));
        toc
    end
 
%%%%%%%4.计算第n波长FWHM和Z轴上光强%%%%%%%
[Ex0,Ey0]=Process_flow(phi,band3(:,PopulationNum),PhaseBandGap3(:,PopulationNum),N,BandNum);
[ratio1,distance1,strength1]=AngularSpectrumDiffraction(Ex0,Ey0,lam3,N);
NA1=sin(atan(R/(distance1*74)));%数值孔径
DL1=0.5/NA1;
fitness=1-(DL1-ratio1);%使用足够大的值1减去，改变比较方向，同时将数据转移到正数范围
if fitness<1
    [Ex0,Ey0]=Process_flow(phi,band2(:,PopulationNum),PhaseBandGap2(:,PopulationNum),N,BandNum);
    [ratio1,distance1,strength1]=AngularSpectrumDiffraction(Ex0,Ey0,lam2,N);
    NA1=sin(atan(R/(distance1*74)));%数值孔径
    DL1=0.5/NA1;
    fitness=1-(DL1-ratio1);
    fitness=fitness/10;
    if fitness<0.1
    [Ex0,Ey0]=Process_flow(phi,band1(:,PopulationNum),PhaseBandGap1(:,PopulationNum),N,BandNum);
    [ratio1,distance1,strength1]=AngularSpectrumDiffraction(Ex0,Ey0,lam1,N);
    NA1=sin(atan(R/(distance1*74)));%数值孔径
    DL1=0.5/NA1;
    fitness=1-(DL1-ratio1);
    fitness=fitness/100;
    end
end
strcat('4.计算第7波长FWHM和Z轴上光强')

%%%%%计算适应度值%%%%%%
Ratio(PopulationNum)=fitness;
Distance(PopulationNum)=distance1;
Strength(PopulationNum)=strength1;
FWHM(PopulationNum)=ratio1;
Dlimit(PopulationNum)=DL1;

if Iteration>0
%%%%更新个体最优%%%%%%%
if Ratio(PopulationNum)<record_Ratio(PopulationNum)
    record_Ratio(PopulationNum)=Ratio(PopulationNum);
    record_Distance(PopulationNum)=Distance(PopulationNum);
    record_Strength(PopulationNum)=Strength(PopulationNum);
    record_band(:,PopulationNum)=band(:,PopulationNum); 
    record_FWHM(PopulationNum)=FWHM(PopulationNum);
    record_Dlimit(PopulationNum)=Dlimit(PopulationNum); 
end
%%%%更新全局最优%%%%%%%
if record_Ratio(PopulationNum)<min_Ratio
    min_Ratio=record_Ratio(PopulationNum);
    min_Distance=record_Distance(PopulationNum);
    min_Strength=record_Strength(PopulationNum);
    min_band=record_band(:,PopulationNum);
    min_FWHM=record_FWHM(PopulationNum);
    min_Dlimit=record_Dlimit(PopulationNum);
end
end

Iteration
PopulationNum
end %每次迭代

if Iteration==0
    for i=1:PopulationAll
    record_band(:,i)=band(:,i);
    record_Ratio(i)=Ratio(i);
    record_Distance(i)=Distance(i);
    record_Strength(i)=Strength(i);
    record_FWHM(i)=FWHM(i);
    record_Dlimit(i)=Dlimit(i);
    end
    [temp1,temp2]=find(record_Ratio==min(record_Ratio));%这里存在一个隐患，即如果初始化的环带一样，变量大小就不一致了
    min_band=record_band(:,temp2(1));
    min_Ratio=record_Ratio(temp2(1));
    min_Distance=record_Distance(temp2(1));
    min_Strength=record_Strength(temp2(1));
    min_FWHM=record_FWHM(temp2(1));
    min_Dlimit=record_Dlimit(temp2(1));
end

figure(3)
subplot(4,1,1)
plot(Iteration,min_Ratio,'O');
hold on
subplot(4,1,2)
plot(Iteration,min_Distance,'.');
hold on
subplot(4,1,3)
plot(Iteration,min_Strength,'*');
hold on 
subplot(4,1,4)
plot(Iteration,[min_FWHM,min_Dlimit],'x');
hold on 
 
range=strcat('A',num2str(Iteration+1));
xlswrite(PathName1,min_band',1,range);
xlswrite(PathName2,[min_Ratio,min_Distance,min_Strength,min_FWHM,min_Dlimit],1,range);
end
toc



