function [ratio1,distance1,strength1]=computing_plot(Z,AllDisplay,wavelenNum,Num)
clc
load('wavelen.mat','wavelen');
Wavelen0=74;%um
% --计算衍射场---------------------------
nn=250;
n1=2*nn+2;
T=46.4;
Dx=T/10;
XX=-(nn*Dx+0.5*Dx):Dx:(nn*Dx+0.5*Dx);
X=XX';

for i=1:Num
    j=n1/2;
    Imax=AllDisplay(j,i);
    while (AllDisplay(j,i)>Imax/2&&j<n1-1)
        j=j+1;
    end
    I1=AllDisplay(j-1,i);
    x1=X(j-1);
    I2=AllDisplay(j,i);
    x2=X(j);
    b=(I2-I1)/(x2-x1);
    c=I2-b*x2;
    FWHM(i)=(0.5*Imax-c)/b*2;%求半宽
    Ipeak(i)=Imax;%峰值
    while (AllDisplay(j,i)<=AllDisplay(j-1,i)&&AllDisplay(j,i)>=AllDisplay(j+1,i)&&j<n1-1)
        j=j+1;
    end
    SideLobe=max(AllDisplay(j:n1,i));
    SL(i)=SideLobe/Imax;
end

[H,L]=find(Ipeak==max(Ipeak));
ratio1=FWHM(L)/wavelen(wavelenNum);
distance1=Z(L)/Wavelen0;
strength1=max(Ipeak);


% figure(1);
% subplot(3,1,1)
% plot(Z/Wavelen0,FWHM/wavelen(wavelenNum),'-.');
% % legend('FWHM');%标记曲线
% subplot(3,1,2)
% plot(Z/Wavelen0,Ipeak,'-.');
% % legend('Ipeak');%标记曲线
% subplot(3,1,3)
% plot(Z/Wavelen0,SL,'-.');
% % legend('SL');%标记曲线
% 
% filename=strcat('Z(Wavelen0)_um_FWHM_Ipeak_SL',num2str(wavelenNum),'.jpg');
% saveas(1,filename);
% 
% Out_data_name=strcat('Z(Wavelen0)_um_FWHM_Ipeak_SL.xlsx');
% DataArray=[(Z/Wavelen0);FWHM/wavelen(wavelenNum);Ipeak;SL];
% xlswrite(Out_data_name,DataArray,wavelenNum,'A1');
% 
% k=n1/2;
% N_display=0;
% Xrange=2*Wavelen0;
% while X(k)<=Xrange
%     N_display=N_display+1;
%     k=k+1;
%     if k==n1
%        break;
%     end
% end
% Font=10;
% figure(2)
% %subplot(37,1,wavelenNum)
% contourf(Z/Wavelen0,X(n1/2-N_display:n1/2+N_display,:)/Wavelen0,AllDisplay(n1/2-N_display:n1/2+N_display,:),100,'LineStyle','none');  
% TWODname=strcat('Total-XZ', '-2DIntensity(X,Z)-',num2str(wavelenNum));
% title(TWODname,'FontName','Times New Roman','fontsize',18,'FontWeight','bold');%fnewname
% hold on;
% colorbar;
% caxis([min(min(AllDisplay)),max(max(AllDisplay))]);
% colormap hot;
% %---------Intensity-----坐标设置
% set(gca,'YLim',[-Xrange/Wavelen0 Xrange/Wavelen0]);%X轴的数据显示范围%这句话对显示2D图很漂亮
% set(gca,'XLim',[Z(1)/Wavelen0,Z(Num)/Wavelen0]);%X轴的数据显示范围%%%%%%%%%%%%%%%%显示坐标
% xlabel('Z','FontName','Times New Roman','fontsize',Font,'FontWeight','bold');
% ylabel('X','FontName','Times New Roman','fontsize',Font,'FontWeight','bold');
% zlabel('Intensity','fontsize',Font,'FontWeight','bold');
% set(gca,'FontName','Times New Roman','FontSize',Font,'FontWeight','bold')%设置坐标轴显示格式
% set(findobj(get(gca,'Children'),'LineWidth',0.5),'LineWidth',2);
% colorbar('FontName','Times New Roman','fontsize',Font,'FontWeight','bold');%改colorbar的字体
% picturename=[ TWODname '.jpg'];
% saveas(2,picturename);







