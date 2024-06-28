function [Ex0,Ey0]=Process_flow(phi,band,PhaseBandGap1,N,GeneNum)
%%%%%%1.划分环带%%%%%%%%%
[Amp_1,Phase_1]=DivideBand(phi,band,PhaseBandGap1,N,GeneNum);
strcat('1.划分环带')

%%%%%%2.细划分采样点%%%%%%
[AmpSamplePoints_1,PhaseSamplePoints_1]=SamplingPoints(Amp_1,Phase_1,N);
strcat('2.细划分采样点')

%%%%%%3.circular polarization%%%%%%
Ex0=AmpSamplePoints_1.*exp(1i*PhaseSamplePoints_1); %线偏振中的X分量
Ey0=AmpSamplePoints_1.*exp(1i*(PhaseSamplePoints_1+pi/2)); %线偏振中的Y分量
clear AmpSamplePoints_1
clear PhaseSamplePoints_1
strcat('3.circular polarization')
end