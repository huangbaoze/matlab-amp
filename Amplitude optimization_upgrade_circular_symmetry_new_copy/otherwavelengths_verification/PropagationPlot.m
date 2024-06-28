clc
clear
close all;
tic
global PathName;global PathName0;global PathName1;global PathName2;global PathName3;
FileName='\(54)_up_circle_28_19_10_discont_gd_gdd_37_4(end)';
PathName='E:\huangbaoze\matlab\Amplitude optimization_upgrade_circular_symmetry_new_copy\otherwavelengths_verification';
PathName0=strcat(PathName,FileName);
PathName1=strcat(PathName0,'\2D_Z3');
PathName2=strcat(PathName0,'\Z(Wavelen0)_um_FWHM_Ipeak_SL3');
PathName3=strcat(PathName0,'\ZItotalDisplay3');
%读入优化好的设计波长下的振幅分布
min_band=xlsread(strcat(PathName0,'\min_band.xlsx'),1);
AmpBand_design=min_band(end,:);%振幅优化
% AmpBand_design=min_band(1,:);%对比振幅不优化和优化对焦斑大小的影响

load('coefficient_matrix1.mat','coefficient_matrix');
load(strcat(PathName0,'\N.mat'),'N');
[~,matchingnum]=xlsread(strcat(PathName0,'\GD_GDD_matching.xlsx'),1,'G1');
for i=1:N+1
    file1=strcat('E:\huangbaoze\matlab\Start_HyperbolicLens\',char(matchingnum(1)),'\Lx_Ly_GD_GDD_rmse_A',num2str(i),'.xlsx');
    Lx_Ly_GD_GDD_rmse_A=xlsread(file1,1);
    A=xlsread(file1,2);
    gap=abs(A(:,19)-AmpBand_design(1,N+2-i));
    g(N+2-i)=min(gap);
    [H,]=find(gap==g(N+2-i));
    matching_j=H(1);
    jrange=strcat('A',num2str(matching_j),':AK',num2str(matching_j));
    jjrange=strcat('A',num2str(N+2-i));
    xlswrite(strcat(PathName0,'\matching_structure.xlsx'),Lx_Ly_GD_GDD_rmse_A(matching_j,:),1,jjrange);
    GDBand(N+2-i)=Lx_Ly_GD_GDD_rmse_A(matching_j,3);
    GDDBand(N+2-i)=Lx_Ly_GD_GDD_rmse_A(matching_j,4);
    AmpBand_37(:,N+2-i)=xlsread(file1,2,jrange)';
    PhaseBandGap_37(:,N+2-i)=xlsread(file1,3,jrange)';
    GDBand1(N+2-i)=coefficient_matrix(4,i);
    GDDBand1(N+2-i)=coefficient_matrix(3,i);
end
    xlswrite(strcat(PathName0,'\matching_structure.xlsx'),AmpBand_37',2);
    xlswrite(strcat(PathName0,'\matching_structure.xlsx'),PhaseBandGap_37',3);
    xlswrite(strcat(PathName0,'\g.xlsx'),g',1);
cd(PathName0);
data=[GDBand' GDDBand' GDBand1' GDDBand1' abs(GDBand'-GDBand1') abs(GDDBand'-GDDBand1')];
xlswrite('GD_GDD_matching.xlsx',data,1,'A1');
cd(PathName);
load(strcat(PathName0,'\phi.mat'),'phi');
load(strcat(PathName0,'\BandNum.mat'),'BandNum');
% load('w.mat','w');
%%%%%%%1.划分环带%%%%%
for i=37:-1:1
[Amp_37,Phase_37]=DivideBand(phi,AmpBand_37(i,:),PhaseBandGap_37(i,:),N,BandNum);
%[Amp_37,Phase_37]=DivideBand(phi,AmpBand_37(i,:),GDBand*(w(i)-w(19))+GDDBand*(w(i)-w(19))^2,N);


%%%%%%2.细划分采样点%%%%%%
processname=strcat('细划分采样点',num2str(i));
[AmpSamplePoints_37,PhaseSamplePoints_37]=SamplingPoints(Amp_37,Phase_37,N);%不能写成类似AmpSamplePoints_37(:,:,i),PhaseSamplePoints_37(:,:,i)形式，因为内存不够
process=processname





%%%%%%3.circular polarization%%%%%%
processname=strcat('circular polarization',num2str(i));
Ex0=AmpSamplePoints_37.*exp(1i*PhaseSamplePoints_37); %线偏振中的X分量
Ey0=AmpSamplePoints_37.*exp(1i*(PhaseSamplePoints_37+pi/2)); %线偏振中的Y分量
clear AmpSamplePoints_37
clear PhaseSamplePoints_37
process=processname





%%%%%%%4.计算各波长FWHM和Z轴上光强%%%%%%%
processname=strcat('计算各波长FWHM和Z轴上光强',num2str(i));
AngularSpectrumDiffraction(Ex0,Ey0,i,N);
clear Ex0
clear Ey0
process=processname
end
toc