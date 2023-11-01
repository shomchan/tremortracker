clear
Fs = 100;             % Sampling frequency                    
T = 1/Fs;             % Sampling period    
L = 0;                  % Length of Signal (initialize)
% t=(0:L-1)*T;
%% Physionet Data Read
[filename,path]=uigetfile("*.txt");
fileid=fopen(filename,'r');
fgetl(fileid);
line=fgetl(fileid);
signal=str2num(line);
while ischar(line) && ~strcmp(line,"end")
    signal=[signal str2num(line)];
    L=L+1;
    line=fgetl(fileid);
end
t = (0:L)*T;        % Time vector
%% Processing of Data and Classification of Tremor
topn=5;
[out1,out2,out3]=tremorClassify(signal,L,Fs,t,topn);
fprintf('Top %d frequencies: %d, %d, %d, %d, %d',topn,out2(2,:));
fprintf('\n%s in %s',out1,filename);
exportgraphics(out3, ['figures\' filename(1:end-4) '_fig.png']);
fclose('all');
function[out1,out2,out3]=tremorClassify(in,length,samplefrequency,time,topn)
fourier=fft(in);
P2 = abs(fourier./length);
P1 = P2(1:length/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f=samplefrequency*(0:0.5*length)/length;
out3=tiledlayout('flow');
nexttile
plot(time,in,'k')
nexttile
plot(f,P1,'k')
[sorted,ind]=sort(P1,'descend');
sortedf=f(ind);
out2=[sorted(1:topn);sortedf(1:topn)];
for i=[1:1:topn]
    if sortedf(i)>3 && sortedf(i)<7
        out1='Parkinsonian Tremor Detected';
        break
    else
        out1='Parkinsonian Tremor NOT Detected';
        continue
    end
end
end