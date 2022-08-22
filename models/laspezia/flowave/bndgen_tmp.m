clc;
clear all;
close all;
%%
%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
% input
Delt0=;                
Tstart=Delt0;
Delt=;
sc=;
Itdate = '2018-11-01';
Dur=167*60;
dirc='/vhe/nasmetocean/projects/be-ready/models/laspezia/timeseries_rst/';

%%
%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
        % making time series file  
filename_timeseries='timeseries_org.bct';
M = dlmread(filename_timeseries,'	',11,1);
M=M(1:size(M,1),1);
Ttot=(numel(M)-1)*60;
t=(Delt0+0:Delt0+Ttot)';
% t=(0:Ttot)';
A=zeros(1,length(t),1);
j=0:60:Ttot;

for k=1:numel(M)-1
    A(1+j(k):j(k+1))=M(k)*ones(60,1);
end
A(end)=A(end-1);A=A';
B=[t,A,A];

%% %making warmup time series
warmtime=Delt0;
t0=(0:warmtime);t0=t0';
t0=[t0(1);t0(end)];
tim0=[t0,M(1)*ones(length(t0),1),M(1)*ones(length(t0),1)];
filename_TEMP='timeseries_tmp.bct';
fid = fopen(filename_TEMP,'r');
i = 1;
tline = fgetl(fid);
ST{i} = tline;
while ischar(tline)
    i = i+1;
    tline = fgetl(fid);
    ST{i} = tline;
end
fclose(fid);
ST=ST(1:10);
replace0 =['records-in-table       ' num2str(length(t0))];
ST{11}=replace0;
fid= fopen(['timeseries.bct_' sprintf('%05d',0)], 'w');
fprintf(fid,'%s\n', ST{:});
dlmwrite(['timeseries.bct_' sprintf('%05d',0)],tim0,'-append','delimiter','\t','precision','%9.7e')
fclose(fid);

%%

for s=1:((size(M,1)-1)*60/Delt)    
p=find(t==Tstart);
tim=B(p:p+Delt,:);
filename_TEMP='timeseries_tmp.bct';
fid = fopen(filename_TEMP,'r');
i = 1;
tline = fgetl(fid);
ST{i} = tline;
while ischar(tline)
    i = i+1;
    tline = fgetl(fid);
    ST{i} = tline;
end
fclose(fid);
ST=ST(1:10);
replace3 =['records-in-table       ' num2str(Delt+1)];
ST{11}=replace3;
id=sprintf('%05d',s);ID{s}=id;
fid= fopen(['timeseries.bct_' ID{s}], 'w');
fprintf(fid,'%s\n', ST{:});
dlmwrite(['timeseries.bct_' ID{s}],tim,'-append','delimiter','\t','precision','%9.7e')
fclose(fid);
movefile (['timeseries.bct_' ID{s}],[dirc sprintf('%03d',sc)])
Tstart=Tstart+Delt;
end
movefile ('timeseries.bct_00000',[dirc sprintf('%03d',sc)])

%%
%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
% making wind file
Tstart=Delt0;
warmtime=Delt0;
t0=(0:warmtime);t0=t0';
t0=[t0(1);t0(end)];
filename_wind='wind_org.wnd';
N = dlmread(filename_wind,'	',0,0);
tin0=[t0,N(1,2)*ones(length(t0),1),N(1,3)*ones(length(t0),1)];
dlmwrite(['wind.wnd_' sprintf('%05d',0)],tin0,'-append','delimiter','\t','precision','%9.7e')

Ns=N(:,2);
Nd=N(:,3);
Cs=zeros(1,length(t),1);
Cd=zeros(1,length(t),1);
for k=1:numel(N(:,1))-1
    Cs(1+j(k):j(k+1))=Ns(k)*ones(60,1);
    Cd(1+j(k):j(k+1))=Nd(k)*ones(60,1);
end
Cs(end)=Cs(end-1);Cs=Cs';
Cd(end)=Cd(end-1);Cd=Cd';
D=[t,Cs,Cd];

for s=1:((size(M,1)-1)*60/Delt)
p=find(t==Tstart);    
wnd=D(p:p+Delt,:);
% delete 'wind.wnd'
dlmwrite(['wind.wnd_' ID{s}],wnd,'-append','delimiter','\t','precision','%9.7e')
movefile (['wind.wnd_' ID{s}],[dirc sprintf('%03d',sc)]) 
Tstart=Tstart+Delt;
end
movefile ('wind.wnd_00000',[dirc sprintf('%03d',sc)])
%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
% quit
  









