clear all;

%%BUTTERWORTH
%TFEST

% Launch the GUI
blackBox

LoadFromFile = 1;
iterations = 5;
plotNoise = 0;
stepSize = 0.0005;

%% Running the GUI
% DESCRIPTIVE TEXT

% Find handle to hidden figure
temp = get(0,'showHiddenHandles');
set(0,'showHiddenHandles','on');
hfig = gcf;
% Get the handles structure
handles = guidata(hfig);

% This will let you pick the File radio button
set(handles.radioFile, 'Value', LoadFromFile);
set(handles.inputFile, 'String', 'inputManual' );

%%Good test: (t - 10)^2 - 5

% This changes the equation in the Field textbox
set(handles.input, 'String', 'sin(3*t)' );
blackBox('input_Callback',handles.input,[],handles);

% This changes the start time
set(handles.axisStart, 'String', '0');
% This changes the end time
set(handles.axisEnd, 'String', '10');
% This changes the step size
set(handles.stepSize, 'String', num2str(stepSize));
% This changes the refine output
set(handles.refineOutput, 'String', '1');

rng(1);
blackBox('run_Callback',handles.run,[],handles);
fileName = strcat('ForButterworth',num2str(1));
set(handles.saveFile, 'String',fileName);
blackBox('save_Callback',handles.save,[],handles);

% for n = 1:iterations
%     rng(n);
%     % Use the run button
%     blackBox('run_Callback',handles.run,[],handles);
% 
%     % This changes the save file name
%     fileName = strcat('saving_file_name',num2str(n));
%     set(handles.saveFile, 'String',fileName);
%     % Use the save button
%     blackBox('save_Callback',handles.save,[],handles);
% end 

clear fileName;
set(0,'showHiddenHandles',temp);
%% Filtering The Data
% DESCRIPTIVE TEXT

f = 1/stepSize;
f_cutoff = 20;

fnorm = f_cutoff/(f/2);
[b1,a1] = butter(10,fnorm,'low');

fileName = strcat('ForButterworth',num2str(1));
dataSet = load(fileName);
signal = dataSet.(fileName).output.signal;

butter_sig = filtfilt(b1,a1,signal);
med_filt = medfilt1(butter_sig,150);

time = dataSet.(fileName).output.time;

figure(1);
freqz(b1,a1,128,f),title('low pass filter characteristics')
figure(2);
subplot(2,1,1), plot(time,signal,time, butter_sig), title('signal')
subplot(2,1,2), plot(time, med_filt), title('butter')

% for n = 1:iterations
%     fileName = strcat('saving_file_name',num2str(n));
%     dataSet = load(fileName);
%     signal(n,:) = dataSet.(fileName).output.signal;
% 
%     filtsig(n,:) = medfilt1(signal(n,:),50);
% end 

% time = dataSet.(fileName).output.time;
% 
% fullFilt = mean(filtsig,1);
% reFilt = medfilt1(fullFilt, 30);
% 
% figure(1);
% title('Filtered Signal');
% if plotNoise == 1
%     rng(1);
%     randArray = randn([length(time),1]);
%     randFilt = medfilt1(randArray,50);
%     plot(time,signal(1,:),time,fullFilt,time,reFilt,time,randArray,time,randFilt)
%     legend('Original','Filtered','ReFiltered','rand','randFilt')
%     legend('boxoff')
% else
%     plot(time,signal(1,:),time,fullFilt,time,reFilt)
%     legend('Original','Filtered','ReFiltered')
%     legend('boxoff')
% end
% 
% hold off


% figure(2)
% plot(time,fullFilt,time,randFilt)

% figure(3);
% title('Noise');
% hold on;
% for n = 1:iterations
%     noise(n,:) = signal(n,:) - fullFilt;
%     rng(1);
%     for k = 1:length(noise(n,:))
%         crushed(n,k) = fullFilt(k)*rand;
%     end
%     crushed = min(abs(crushed), 10);
%     plot(time,noise(n,:),time,crushed(n,:))
% end
% hold off;