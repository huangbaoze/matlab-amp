function [Amp,Phase]=DivideBand(phi,AmpBand,PhaseBandGap,N,BandNum)


M=2*N+1;%纵横坐标点数
for i=1:M
    for j=1:M
        if BandNum(i,j)==0%边缘标记为0，舍弃该周期结构位置，振幅置为0
            Amp(i,j)=0;
            Phase(i,j)=0;
        else
            Amp(i,j)=AmpBand(N+2-BandNum(i,j));
            Phase(i,j)=phi(i,j)+PhaseBandGap(N+2-BandNum(i,j));
        end
    end
end


