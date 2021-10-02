function out = lpc_somi(file)
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
%
%
% LP analysis code starts here
% 
%

flag2=1;
flag3=0;

[sig, Fs] = audioread(file);
info=audioinfo(file);
sig=sig(:,1);

Horizon =50;  %30ms - window length
OrderLPC =40;   %order of LPC
Buffer = 0;    % initialization
out = zeros(size(sig)); % initialization

Horizon = Horizon*Fs/1000;
Shift = Horizon/2;       % frame size - step size
Win = hanning(Horizon);  % analysis window

Lsig = length(sig);
slice = 1:Horizon;
tosave = 1:Shift;
Nfr = floor((Lsig-Horizon)/Shift)+1;  % number of frames

% analysis frame-by-frame
for l=1:Nfr
    
  sigLPC = Win.*sig(slice);
  en = sum(sigLPC.^2); % get the short - term energy of the input
  
  % LPC analysis
  r =  xcorr(sigLPC); % correlation
  r = r./max(abs(r));
  [a,g]=lpc(sigLPC,OrderLPC);% LPC coef.
  G = 10 ;% gain
  ex = filter([0 -1*a(2:end)],1,sigLPC); % inverse filter
  % LP Residual Part 
  lp_res=sigLPC-ex;

  % synthesis
  s = filter(G,a,lp_res);
  ens = sum(s.^2);   % get the short-time energy of the output
  g = sqrt(en/ens);  % normalization factor
  s  =s*g;           % energy compensation
  s(1:Shift) = s(1:Shift) + Buffer;  % Overlap and add
  out(tosave) = s(1:Shift);           % save the first part of the frame
  Buffer = s(Shift+1:Horizon);       % buffer the rest of the frame
  
  slice = slice+Shift;   % move the frame
  tosave = tosave+Shift;
end

% Net Reconstructed error.

out(isnan(out))=0;
sig(isnan(sig))=0;
err=minus(sig,out);



% Out computation is done ,we need to audio-write it . 
outFile=append('result_',file);
errFile=append('err_',file);
audiowrite(errFile,err,Fs);
audiowrite(outFile,out,Fs);

% Output Sound
sound(out,Fs);

% Plotting it out (Emtire Speech and reconstructed part)
if(flag2)
      figure; 
      t=linspace(0,length(sig),length(sig));
      subplot(3,1,1)
      plot(t,sig);
      xlabel('Time');
      ylabel('Speech Frame'); 
      grid on;
    
      subplot(3,1,2)
      plot(t,out);
      xlabel('Time');
      ylabel('Predicted Speech Frame'); 
      grid on;
      
      subplot(3,1,3)
      plot(t,err);
      xlabel('Time');
      ylabel('Error Speech Frame'); 
      grid on;
end


end


