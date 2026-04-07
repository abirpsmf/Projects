
clear
clc
close all


load('data/97.mat')  %loading Healthy Motor daata
whos

normal_signal= X097_DE_time;


load('data/IR007_0.mat') %loading Faulty Motor data

fault_signal= X105_DE_time;



fs= 12000; %sampling frequency

%converting samples to time 

t_normal=(0:length(normal_signal)-1)/fs;  %time vector (HEALTHY MOTOR)

t_fault= (0:length(fault_signal)-1)/fs;  %time vector (FAULTY MOTOR)





% Raw Vibration Signal comparison           #1

figure      
tiledlayout(2,1)

nexttile
plot(t_normal,normal_signal)
title('Motor Vibration Signal (Healthy)')
xlabel('Time(s)');
ylabel('Amplitude');

nexttile
plot(t_fault, fault_signal)
xlabel('Time(s)')
ylabel('Amplitude')
title('Faulty MOtor Vibration Signal (Faulty)')

%FFT on Raw Signals
N=length(normal_signal);          %NORMAL SIGNAL
Y=fft(normal_signal);
f=(0:N-1)*(fs/N);

N_fault=length(fault_signal);      %FAULTY SIGNAL
Y_fault=fft(fault_signal);
f_fault = (0:N_fault-1)*(fs/N_fault);



%FFT FIGURE                           #2

figure
tiledlayout(2,1)

nexttile
plot(f, abs(Y))
xlabel('Frequency(Hz)')
ylabel('Magnitude')
title('Frequency Spectrum (HEALTHY MOTOR)')
xlim([0 1000])

nexttile
plot(f_fault, abs(Y_fault))
xlabel('Frequency (Hz)')
ylabel('Magnitude')
title('Frequency Spectrum (FAULTY MOTOR)')
xlim([0 1000])



%healthy motor peaks
[peaks_h, locs_h] = findpeaks(abs(Y), f, 'MinPeakHeight', 0.01);

disp('Healthy motor peak frequencies:')
disp(locs_h(1:min(10, end)))

%faulty motor peaks
[peaks_f, locs_f] = findpeaks(abs(Y_fault), f_fault, 'MinPeakHeight', 0.01);
disp('Faulty motor peak frequencies:');
disp(locs_f(1:min(10,end)));

figure
plot(f_fault,abs(Y_fault))
hold on 
plot(locs_f, peaks_f, 'ro')
xlim([0 1000])
title ('Faulty Motor Specturm with Detected Peaks')
xlabel('Frequency (Hz)')
ylabel('Magnitude')


%enveloping 

                                        %for faulty signal
analytic_fault= hilbert(fault_signal);
envelope_fault =abs(analytic_fault);

                                        %for healthy signal
analytic_normal= hilbert(normal_signal);
envelope_normal= abs(analytic_normal);

t_fault= (0:length(fault_signal)-1)/fs;
t_healthy=(0:length(normal_signal)-1)/fs;

%Plotting envelopes                 #3
figure
tiledlayout(2,1)

nexttile
plot(t_normal, envelope_normal)
xlabel('Time (seconds)')
ylabel('Amplitude')
title('Envelope Signal (Healthy Motor)')

nexttile
plot(t_fault, envelope_fault)
xlabel('Time (seconds)')
ylabel('Amplitude')
title('Envelope Signal (Faulty Motor)')
% Performing FFT on envelope

% For faulty
N_env_f = length(envelope_fault);
Y_env_f = fft(envelope_fault);

P2f = abs((Y_env_f / N_env_f));
P1f = P2f(1:(N_env_f/2) + 1);
P1f(2:end-1) = 2 * P1f(2:end-1);

f_env_f = fs * (0:(N_env_f/2)) / N_env_f;  %faulty frequency

% For healthy
N_env_n = length(envelope_normal);
Y_env_n = fft(envelope_normal);


P2n = abs(Y_env_n / N_env_n);
P1n = P2n(1:N_env_n/2 + 1);
P1n(2:end-1) = 2 * P1n(2:end-1);

f_env_n = fs * (0:(N_env_n/2)) / N_env_n;   %normal frequency

% Envelope Spectrum #4
figure
tiledlayout(2,1)

nexttile
plot(f_env_n, P1n)
xlabel('Frequency (Hz)')
ylabel('Magnitude')
title('Healthy Motor Envelope Spectrum')
xlim([0 500])
grid on

nexttile
plot(f_env_f, P1f)
xlabel('Frequency (Hz)')
ylabel('Magnitude')
title('Faulty Motor Envelope Spectrum')
xlim([0 500])
grid on



