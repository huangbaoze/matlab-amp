clc;clear;
% --计算衍射场---------------------------
nn=250;
n1=2*nn+2;
filename='E:\huangbaoze\matlab\Amplitude optimization_upgrade_circular_symmetry_new_copy\otherwavelengths_verification\(54)_up_circle_28_19_10_discont_gd_gdd_37_4(end)\ZItotalDisplay3\ZItotalDisplay';
for i=1:37
    AllDisplay=xlsread(strcat(filename,num2str(i),'.xlsx'),1);
    j=n1/2;
    Imax(i)=max(AllDisplay(j,:));
    k=find(AllDisplay(j,:)==Imax(i));
    while (AllDisplay(j,k)>10&&k>2)
        k=k-1;
    end
    
    while (AllDisplay(j,k)<=AllDisplay(j,k+1)&&AllDisplay(j,k)>=AllDisplay(j,k-1)&&k>2)
        k=k-1;
    end
    SideLobe(i)=max(AllDisplay(j,1:k));
    SL(i)=SideLobe(i)/Imax(i);
end
xlswrite(strcat(filename,'_SideLobe_Imax_SL3.xlsx'),[SideLobe;Imax;SL],1,'A1');


