function out = lpc_freq(file)
%
% INPUT:
%   file: input filename of a wav file
% OUTPUT:
%   out: a vector contaning the output signal
%
% Example:
%   
%   out = lpc_try('1_H.wav');
%   [sig,fs]= audioread('1_H.wav');
%   sound(out,fs);
%   sound(sig,fs);
%   sound([out [zeros(2000,1);sig(1:length(sig)-2000)]],fs); % create echo

flag=1;

[sig, Fs] = audioread(file);
info=audioinfo(file)
sig=sig(:,1);

Lsig = length(sig);
OrderLPC =100;   %order of LPC
out = zeros(size(sig)); % initialization

Win = hanning(Lsig);  % analysis window

Lsig = length(sig);
sigLPC = Win.*sig;
en = sum(sigLPC.^2); % get the short - term energy of the input

% LPC analysis
r =  xcorr(sigLPC); % correlation
r = r./max(abs(r));
[a,g]=lpc(sigLPC,OrderLPC);% LPC coef.
G = 1 ;% gain
ex = filter([0 -1*a(2:end)],1,sigLPC); % inverse filter
% LP Residual Part 
lp_res=sigLPC-ex;

% synthesis
s = filter(G,a,ex);
ens = sum(s.^2);   % get the short-time energy of the output
g = sqrt(en/ens);  % normalization factor
s =s*g;           % energy compensation


% SNR Computation : 

out(isnan(out))=0;
sig(isnan(sig))=0;
err=minus(sig,s);

denom=abs(err);
num=abs(sig);
disp('SNR is : ')
r = snr(num,denom) 

% Plotting frame analysis
  if(flag)
      
      figure;
      
      hold on;
      
      [h,f] = freqz(1,a,Lsig,'whole',Fs);
      z=20*log10(abs(h));
      plot(z)
      xlabel('Frequency');
      ylabel('Fitered Frequency Frame'); 
      grid on;
      y=20*log10(abs(fft(sigLPC)));
      plot(y);
      xlabel('Frequency');
      ylabel('FFT Speech Frame'); 
      grid on;
      
      hold off;
      
      
  end
 
% % Out computation is done ,we need to audio-write it . 
% outFile=append('result_',file);
% errFile=append('err_',file);
% audiowrite(errFile,err,Fs);
% audiowrite(outFile,out,Fs);

% Output Sound
% sound(out,Fs)
end