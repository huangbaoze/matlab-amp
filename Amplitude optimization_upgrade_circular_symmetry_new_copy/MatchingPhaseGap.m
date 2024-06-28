function [bandtmp10,phasegaptmp10,bandtmp,phasegaptmp,bandtmp28,phasegaptmp28]=MatchingPhaseGap(band,N,matchingnum)
      
for bandnum=1:N+1
    file=strcat('D:\Fen Zhao\Amplitude optimization_upgrade_circular_symmetry_new\matching\',matchingnum,'\Lx_Ly_GD_GDD_rmse_A',num2str(N+2-bandnum),'.xlsx');
    matchingdataA=xlsread(file,2);
    matchingdataP=xlsread(file,3);
    matchingA=matchingdataA(:,19);
    matchingP=matchingdataP(:,19);
    matchingA10=matchingdataA(:,10);
    matchingP10=matchingdataP(:,10);
    matchingA28=matchingdataA(:,28);
    matchingP28=matchingdataP(:,28);
    matchinggap=abs(matchingA-band(bandnum));
    min_matchinggap(bandnum)=min(matchinggap);
    [matchingH,~]=find(matchinggap==min_matchinggap(bandnum));
    bandtmp(bandnum)=matchingA(matchingH(1));
    phasegaptmp(bandnum)=matchingP(matchingH(1));
    bandtmp10(bandnum)=matchingA10(matchingH(1));
    phasegaptmp10(bandnum)=matchingP10(matchingH(1));
    bandtmp28(bandnum)=matchingA28(matchingH(1));
    phasegaptmp28(bandnum)=matchingP28(matchingH(1));
end
figure(4)
plot(1:N+1,min_matchinggap,'.');
end