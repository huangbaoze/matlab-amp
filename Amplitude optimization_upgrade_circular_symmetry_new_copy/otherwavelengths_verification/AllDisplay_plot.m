function AllDisplay_plot(wavelenNum,AllDisplayFocus)
Wavelen0=74;%um
nn=250;
n1=2*nn+2;
T=46.4;
Dx=T/24;
XX=-(nn*Dx+0.5*Dx):Dx:(nn*Dx+0.5*Dx);
YY=XX';
X=XX';
k=n1/2;
N_display=0;
Xrange=2*Wavelen0;
while X(k)<=Xrange
    N_display=N_display+1;
    k=k+1;
    if k==n1
       break;
    end
end

filepath='E:\huangbaoze\matlab\Amplitude optimization\otherwavelengths_verification';
Font=10;
set(0,'defaultfigurecolor','w')
% figure(1)
% surf(X(n1/2-N_display:n1/2+N_display,:)/Wavelen0,YY(n1/2-N_display:n1/2+N_display,:)/Wavelen0,AllDisplayFocus(n1/2-N_display:n1/2+N_display,n1/2-N_display:n1/2+N_display));
% view([-45,45]);%图像45度角
% TWODname=strcat('Total-XY', '-3DIntensity(X,Y)-',num2str(wavelenNum));
% title(TWODname,'fontsize',Font);%fnewname
% xlabel('XX','fontsize',Font);
% ylabel('YY','fontsize',Font);
% zlabel('Intensity','fontsize',Font);
% set(gca,'FontName','Times New Roman','FontSize',Font)
% % set(gca,'linewidth',3) %| 设置图形外边框的线宽1.5
% set(findobj(get(gca,'Children'),'LineWidth',0.5),'LineWidth',2);
% colorbar('FontSize',Font);%改colorbar的字体
% set(gca,'YLim',[-Xrange/Wavelen0 Xrange/Wavelen0]);%X轴的数据显示范围%这句话对显示3D图很漂亮
% set(gca,'XLim',[-Xrange/Wavelen0 Xrange/Wavelen0]);%X轴的数据显示范围%%%%%%%%%%%%%%%%显示坐标
% shading interp%取消网格
% cd('E:\huangbaoze\matlab\Amplitude optimization\otherwavelengths_verification\3D');
% picturename=[ TWODname '.jpg'];
% saveas(1,picturename);
% cd(filepath);


figure(1)
contourf(X(n1/2-N_display:n1/2+N_display,:)/Wavelen0,YY(n1/2-N_display:n1/2+N_display,:)/Wavelen0,AllDisplayFocus(n1/2-N_display:n1/2+N_display,n1/2-N_display:n1/2+N_display),100,'LineStyle','none');  
TWODname=strcat('Total-XY', '-2DIntensity(X,Y)-',num2str(wavelenNum));
title(TWODname,'FontName','Times New Roman','fontsize',18,'FontWeight','bold');%fnewname
hold on;
colorbar;
colormap hot;
%---------Intensity-----坐标设置
set(gca,'YLim',[-Xrange/Wavelen0 Xrange/Wavelen0]);%X轴的数据显示范围%这句话对显示3D图很漂亮
set(gca,'XLim',[-Xrange/Wavelen0 Xrange/Wavelen0]);%X轴的数据显示范围%%%%%%%%%%%%%%%%显示坐标
% axis([200 400 -20 20]);
xlabel('XX','FontName','Times New Roman','fontsize',Font,'FontWeight','bold');
ylabel('YY','FontName','Times New Roman','fontsize',Font,'FontWeight','bold');
zlabel('Intensity','fontsize',Font,'FontWeight','bold');
set(gca,'FontName','Times New Roman','FontSize',Font,'FontWeight','bold')%设置坐标轴显示格式
set(findobj(get(gca,'Children'),'LineWidth',0.5),'LineWidth',2);
colorbar('FontName','Times New Roman','fontsize',Font,'FontWeight','bold');%改colorbar的字体
cd('E:\huangbaoze\matlab\Amplitude optimization\otherwavelengths_verification\2D(GD_GDD)');
picturename=[ TWODname '.jpg'];
saveas(1,picturename);
cd(filepath);

    
