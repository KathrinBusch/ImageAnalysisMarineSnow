%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Purpose: Script to evaluate numbers of particle attached bacteria in relation to particle size by correlative 
%      brightfield and epifluorescent microscopy. Step 2.
% Author: Kathrin Busch (GEOMAR, Department of Marine Biogeochemistry | Microbial Oceanography)
% Date : 2016-01-30
% Language: MATLAB
% Programm version: MATLAB R2011a 
% Literature Reference(s): Detailed description in Busch et al. 2017 (esp. Supplementary material S4).
% Note(s): Usually this script runs without an error message to the end, where I added a 'proof paragraph'. 
%      This proof paragraph accomplishes that, when the routine has finished, values for 'Bacterial Abundance', 
%      'Total Area' and 'Particle Number' appear in the Matlab command window. The two values appearing for each parameter
%      should be the same (accuracy to the first decimal place). If they are not the same, most probably at least one of the
%      manually tuned threshold windows was not set to the same value as the priorly adjusted threshold in ImageJ. 
%      In this case, the ImageJ analysis has to be conducted again for the respective batch. If an error message occurs 
%      instead of the proof paragraph, the problem is most likely that no bacteria were found on the very last analysed 
%      picture. If this is the case, Matlab cannot load the results sheet to create the summary vector. 
%      I suggest to open the incompletely produced Excel result sheet and to manually enter a 0 into the last 'Bac'-column. 
%      Afterwards the Matlab routine should be re-run to replace the incomplete by a complete result sheet.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

R=importdata('ResultsParticlesALL.txt');
data=R.data(:,[2:5]); 
headers= R.colheaders(:,[2:5]);  
ds=dataset({data,headers{:}});
ParticleNumber=sum(ds.Count);  
TotalArea=sum(ds.TotalArea);  
xlswrite('MatlabResults',ParticleNumber,'1','A2') ; 
xlswrite('MatlabResults',TotalArea,'1','B2') ;
clear()
col_header={'ParticleNumber','TotalArea','BacterialAbundance','Area1', 'Bac1', 'Area2', 'Bac2','Area3', 'Bac3', 'Area4', 'Bac4', 'Area5', 'Bac5', 'Area6', 'Bac6', 'Area7', 'Bac7', 'Area8', 'Bac8', 'Area9', 'Bac9', 'Area10', 'Bac10'};   
xlswrite('MatlabResults',col_header,'1','A1');    
clear()

%%%%%%%%% Run loop 10 times, with consecutive labelling, if you have 10 images per batch: 
for i=1:1
    try 
        M=importdata('1ResultsParticles.txt');  
        data=M.data(:,[2:17]); 
        headers= M.colheaders(:,[2:17]); 
        ds=dataset({data,headers{:}});
        Area1=ds.Area;
        xlswrite('MatlabResults',Area1,'1','D2')  
        BXraw=ds.BX;
        BYraw=ds.BY;
        Width=ds.Width;
        Height=ds.Height;
        N=importdata('1ResultsBac.txt');
        data=N.data(:,[2:17]);  
        headers= N.colheaders(:,[2:17]);  
        ds=dataset({data,headers{:}});
        X=ds.X;
        Y=ds.Y;
        BX2 = BXraw+Width;
        BY2 = BYraw+Height;
        BX=BXraw;
        BY=BYraw;   
        [E]=meshgrid(length(BX),length(X));
            for i=1:1:length(BX)
                for j = 1:1:length(X)
                    if BX(i)<X(j) && BX2(i)>X(j) && BY(i)<Y(j) && BY2(i)>Y(j)
                    E(i,j)=1;
                    else 
                    E(i,j)=0;
                    end
                end
            end           
            num=1:1:length(BX);
            for k=1:1:length(BX)
                num(k)=sum(E(k,:));
            end
            Bac1=transpose(num);                    
            xlswrite('MatlabResults',Bac1,'1','E2')  
    end
end
           
clear()
%%%%%%%%%

[num,txt,raw]=xlsread('MatlabResults.xls','1');
ds=dataset({num,txt{:}});
BacterialAbundance=nansum(ds.Bac1)+ nansum (ds.Bac2)+ nansum (ds.Bac3)+ nansum (ds.Bac4)+ nansum (ds.Bac5)+ nansum (ds.Bac6)+ nansum (ds.Bac7)+ nansum (ds.Bac8)+ nansum (ds.Bac9)+ nansum (ds.Bac10);
xlswrite('MatlabResults',BacterialAbundance,'1','C2')
[num,txt,raw]=xlsread('MatlabResults.xls','1');
ds=dataset({num,txt{:}});
 
AllBac=[ds.Bac1;ds.Bac2;ds.Bac3;ds.Bac4;ds.Bac5;ds.Bac6;ds.Bac7;ds.Bac8;ds.Bac9;ds.Bac10];
AllArea=[ds.Area1;ds.Area2;ds.Area3;ds.Area4;ds.Area5;ds.Area6;ds.Area7;ds.Area8;ds.Area9;ds.Area10];
xlswrite('MatlabResults',AllBac,'1','Y2')
xlswrite('MatlabResults',AllArea,'1','Z2')
col_header={'AllBac'};   
xlswrite('MatlabResults',col_header,'1','Y1');  
col_header={'AllArea'};   
xlswrite('MatlabResults',col_header,'1','Z1'); 
  
%%%%%%%%% Proof
ds=dataset({num,txt{:}});
BacterialAbundance=nansum(ds.Bac1)+ nansum (ds.Bac2)+ nansum (ds.Bac3)+ nansum (ds.Bac4)+ nansum (ds.Bac5)+ nansum (ds.Bac6)+ nansum (ds.Bac7)+ nansum (ds.Bac8)+ nansum (ds.Bac9)+ nansum (ds.Bac10)
nansum(ds.BacterialAbundance)
TotalArea= nansum(ds.Area1)+nansum(ds.Area2)+nansum(ds.Area3)+nansum(ds.Area4)+nansum(ds.Area5)+nansum(ds.Area6)+nansum(ds.Area7)+ nansum(ds.Area8)+nansum(ds.Area9)+nansum(ds.Area10)
nansum(ds.TotalArea)
ParticleNumber=numel(ds.Area1)-sum(isnan(ds.Area1))+numel(ds.Area2)-sum(isnan(ds.Area2))+numel(ds.Area3)-sum(isnan(ds.Area3))+numel(ds.Area4)-sum(isnan(ds.Area4))+numel(ds.Area5)-sum(isnan(ds.Area5))+numel(ds.Area6)-sum(isnan(ds.Area6))+numel(ds.Area7)-sum(isnan(ds.Area7))+numel(ds.Area8)-sum(isnan(ds.Area8))+numel(ds.Area9)-sum(isnan(ds.Area9))+numel(ds.Area10)-sum(isnan(ds.Area10))
nansum(ds.ParticleNumber)
clear()