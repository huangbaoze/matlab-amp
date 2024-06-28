clc
clear
close all;
tic
%读入优化好的设计波长下的振幅分布
min_band=xlsread('E:\huangbaoze\matlab\Amplitude optimization\otherwavelengths_verification\min_band2.xlsx',1);
AmpBand_design=min_band(101,:);
tmp=1;
for i=1:235
    file1=strcat('E:\huangbaoze\matlab\Amplitude optimization\otherwavelengths_verification\matching_GD_GDD2\Lx_Ly_GD_GDD_rmse_A',num2str(i),'.xlsx');
    Lx_Ly_GD_GDD_rmse_A=xlsread(file1,1);
    [H,L]=size(Lx_Ly_GD_GDD_rmse_A);
    for j=1:H
       gap=abs(Lx_Ly_GD_GDD_rmse_A(j,6)-AmpBand_design(1,236-i));
       if gap<tmp
           %matching_A(1,i)=Lx_Ly_GD_GDD_rmse_A(j,6);           
           matching_j=j;
           tmp=gap;
       end
    end
    tmp=1;
    jrange=strcat('A',num2str(matching_j),':AK',num2str(matching_j));
    AmpBand_37(:,236-i)=xlsread(file1,2,jrange)';
    PhaseBandGap_37(:,236-i)=xlsread(file1,3,jrange)';
end

load('phi.mat','phi');
%%%%%%%划分环带%%%%%

[Amp_37,Phase_37]=DivideBand(phi,AmpBand_37(19,:),PhaseBandGap_37(19,:));