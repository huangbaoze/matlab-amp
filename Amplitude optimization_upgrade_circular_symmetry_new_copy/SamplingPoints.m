function [AmpSamplePoints,PhaseSamplePoints]=SamplingPoints(AmpSample,PhaseSample,N)


M=2*N+1;%纵横坐标点数
mm=10*M;
for i=1:mm
   for  j=1:mm
        ti=i/10;
        tj=j/10;
        ii=floor(ti);
        jj=floor(tj);
        if (ii<ti)&&(jj<tj)
            ii=ii+1;
            jj=jj+1;
        else 
            if (ii==ti)&&(jj<tj)
                jj=jj+1;
            else 
                 if (ii<ti)&&(jj==tj)
                     ii=ii+1;
                 end
             end
        end
          PhaseSamplePoints(i,j)=PhaseSample(ii,jj);
          AmpSamplePoints(i,j)=AmpSample(ii,jj);  
    end
end