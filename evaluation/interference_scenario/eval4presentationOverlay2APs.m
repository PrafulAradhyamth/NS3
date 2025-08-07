clear all
close all
clc


%% EVAL
filen1 = 'BSS1_results.mat';
load(filen1)


min_lim = 1;
max_lim = 67000;
%%
figure(11)
xaxis = results.latency.time;
xaxis_bss1 = results.latency.xaxis+1;
time_bss1 = results.latency.time;
tput_bss1 = results.tput.data;
tput_time_bss1 = results.tput.time;

yaxis = results.latency.congestion.data./1e-6;

plot(xaxis(min_lim:max_lim),yaxis(min_lim:max_lim),'Marker','v','LineStyle','none')
% set(gca,'ColorOrderIndex',1)
hold on

% xaxis = results.latency.time;
% yaxis = results.latency.aggregation.data./1e-6;
% plot(xaxis(min_lim:max_lim),yaxis(min_lim:max_lim),'Marker','s','LineStyle','none')
% xaxis = results.latency.time;
% yaxis = results.latency.firstTX.data./1e-6;
% plot(xaxis(min_lim:max_lim),yaxis(min_lim:max_lim),'Marker','x','LineStyle','none')
% xaxis = results.latency.time;
% yaxis = results.latency.ack.data./1e-6;
% plot(xaxis(min_lim:max_lim),yaxis(min_lim:max_lim),'Marker','d','LineStyle','none')
xaxis = results.latency.time;
yaxis = results.latency.retry.data./1e-6;
plot(xaxis(min_lim:max_lim),yaxis(min_lim:max_lim),'Marker','s','LineStyle','none')
% set(gca,'ColorOrderIndex',1)

e2e_woAck_bss1 = results.latency.congestion.data./1e-6 + results.latency.aggregation.data./1e-6 + results.latency.retry.data./1e-6;

e2e_wAck_bss1 = results.latency.congestion.data./1e-6 + results.latency.aggregation.data./1e-6 + results.latency.retry.data./1e-6 + results.latency.ack.data./1e-6;

plot(xaxis(min_lim:max_lim),e2e_woAck_bss1(min_lim:max_lim),'Marker','x','LineStyle','none')
plot(xaxis(min_lim:max_lim),e2e_wAck_bss1(min_lim:max_lim),'Marker','x','LineStyle','none')
% set(gca,'ColorOrderIndex',2)

filen2 = 'BSS2_results.mat';
load(filen2)
xaxis = results.latency.time;

xaxis_bss2 = results.latency.xaxis+1;
time_bss2 = results.latency.time;
tput_bss2 = results.tput.data;
tput_time_bss2 = results.tput.time;

yaxis = results.latency.congestion.data./1e-6;
plot(xaxis(min_lim:max_lim),yaxis(min_lim:max_lim),'Marker','d','LineStyle','none')
% set(gca,'ColorOrderIndex',2)
hold on
xaxis = results.latency.time;
yaxis = results.latency.retry.data./1e-6;
plot(xaxis(min_lim:max_lim),yaxis(min_lim:max_lim),'Marker','p','LineStyle','none')
% set(gca,'ColorOrderIndex',2)

e2e_woAck_bss2 = results.latency.congestion.data./1e-6 + results.latency.aggregation.data./1e-6 + results.latency.retry.data./1e-6;
e2e_wAck_bss2 = results.latency.congestion.data./1e-6 + results.latency.aggregation.data./1e-6 + results.latency.retry.data./1e-6 + results.latency.ack.data./1e-6;

plot(xaxis(min_lim:max_lim),e2e_woAck_bss2(min_lim:max_lim),'Marker','o','LineStyle','none')
plot(xaxis(min_lim:max_lim),e2e_wAck_bss2(min_lim:max_lim),'Marker','o','LineStyle','none')

hold off
grid on

xlabel('Time of first transmission of an MPDU')
ylabel('Latency [µs]')
legend('Congestion AP1','Retry AP1','e2e w/o Ack AP1','e2e w/ Ack AP1','Congestion AP2','Retry AP2','e2e w/o Ack AP2','e2e w/ Ack AP2','Location','NorthEast')




fig=figure; set(fig,'visible','off');
hist_lat_noAck_x = [0:50e3 inf];
hist_h = histogram(e2e_woAck_bss1(min_lim:max_lim),hist_lat_noAck_x,'Normalization','cdf');
hist_lat_noAck_x = hist_lat_noAck_x(1:end-1);
hist_lat_noAck_bss1 = hist_h.Values;
close(fig);

fig=figure; set(fig,'visible','off');
hist_lat_ack_x = [0:50e3 inf];
hist_h = histogram(e2e_wAck_bss1(min_lim:max_lim),hist_lat_ack_x,'Normalization','cdf');
hist_lat_ack_x = hist_lat_ack_x(1:end-1);
hist_lat_ack_bss1 = hist_h.Values;
close(fig);

fig=figure; set(fig,'visible','off');
hist_lat_noAck_x = [0:50e3 inf];
hist_h = histogram(e2e_woAck_bss2(min_lim:max_lim),hist_lat_noAck_x,'Normalization','cdf');
hist_lat_noAck_x = hist_lat_noAck_x(1:end-1);
hist_lat_noAck_bss2 = hist_h.Values;
close(fig);

fig=figure; set(fig,'visible','off');
hist_lat_ack_x = [0:50e3 inf];
hist_h = histogram(e2e_wAck_bss2(min_lim:max_lim),hist_lat_ack_x,'Normalization','cdf');
hist_lat_ack_x = hist_lat_ack_x(1:end-1);
hist_lat_ack_bss2 = hist_h.Values;
close(fig);

fig=figure; set(fig,'visible','off');
hist_lat_noAck_x = [0:50e3 inf];
hist_h = histogram(e2e_woAck_bss2(max_lim:end),hist_lat_noAck_x,'Normalization','cdf');
hist_lat_noAck_x = hist_lat_noAck_x(1:end-1);
hist_lat_noAck_bss2_singleBSSref = hist_h.Values;
close(fig);

fig=figure; set(fig,'visible','off');
hist_lat_ack_x = [0:50e3 inf];
hist_h = histogram(e2e_wAck_bss2(max_lim:end),hist_lat_ack_x,'Normalization','cdf');
hist_lat_ack_x = hist_lat_ack_x(1:end-1);
hist_lat_ack_bss2_singleBSSref = hist_h.Values;
close(fig);

figure(13)
plot(hist_lat_noAck_x,hist_lat_noAck_bss1)
hold on
set(gca,'ColorOrderIndex',1)
plot(hist_lat_ack_x,hist_lat_ack_bss1,'LineStyle','-.')
plot(hist_lat_noAck_x,hist_lat_noAck_bss2)
set(gca,'ColorOrderIndex',2)
plot(hist_lat_ack_x,hist_lat_ack_bss2,'LineStyle','-.')
set(gca,'ColorOrderIndex',5)
plot(hist_lat_noAck_x,hist_lat_noAck_bss2_singleBSSref)
set(gca,'ColorOrderIndex',5)
plot(hist_lat_ack_x,hist_lat_ack_bss2_singleBSSref,'LineStyle','-.')

hold off
grid on
xlabel('End-to-end latency [µs]')
ylabel('CDF')
legend('w/o Ack STA 1','w/ Ack STA 1','w/o Ack STA 2','w/ Ack STA 2','w/o Ack single BSS ref','w/ Ack single BSS ref','Location','SouthEast')
set(get(gca,'XAxis'),'Exponent',3)
ylim([0 1])
%%



time_bss1 = time_bss1-time_bss1(1);

pdf_res = 11;

avg_lat_container = zeros(ceil(time_bss1(end)*2),1);
min_lat = inf.*ones(ceil(time_bss1(end)*2),1);
max_lat = zeros(ceil(time_bss1(end)*2),1);
lat_occur = zeros(ceil(time_bss1(end)*2),1);

lat_pdf = zeros(ceil(time_bss1(end)*2),pdf_res);

for c = xaxis_bss1(1):xaxis_bss1(end)
    index = floor(time_bss1(c)*2)+1;
    avg_lat_container(index) = avg_lat_container(index) + e2e_woAck_bss1(c);
    min_lat(index) = min([min_lat(index) e2e_woAck_bss1(c)]);
    max_lat(index) = max([max_lat(index) e2e_woAck_bss1(c)]);
    lat_occur(index) = lat_occur(index)+1;
end

avg_lat = avg_lat_container./lat_occur;

time_axis = 0:0.5:floor(time_bss1(end)*2)/2;

figure(14)
yyaxis left
semilogy(time_axis,avg_lat./1e3,'Color',[0 0 1])
hold on
semilogy(time_axis,min_lat./1e3,'Color',[0 0 1])
semilogy(time_axis,max_lat./1e3,'LineStyle','-.','Color',[0 0 1])
hold off
ylabel('Latency w/o Ack [ms] [0.5s window]')

yyaxis right
plot(tput_time_bss1,tput_bss1./1e6,'Color',[0.85 0.33 0.1])
grid on
xlabel('time [s] or distance [m]')
ylabel('Throughput [Mbps] [0.5s average]')
legend('avg','min','max')


time_bss2 = time_bss2-time_bss2(1);

pdf_res = 11;

avg_lat_container = zeros(ceil(time_bss2(end)*2),1);
min_lat = inf.*ones(ceil(time_bss2(end)*2),1);
max_lat = zeros(ceil(time_bss2(end)*2),1);
lat_occur = zeros(ceil(time_bss2(end)*2),1);

lat_pdf = zeros(ceil(time_bss2(end)*2),pdf_res);

for c = xaxis_bss2(1):xaxis_bss2(end)
    index = floor(time_bss2(c)*2)+1;
    avg_lat_container(index) = avg_lat_container(index) + e2e_woAck_bss2(c);
    min_lat(index) = min([min_lat(index) e2e_woAck_bss2(c)]);
    max_lat(index) = max([max_lat(index) e2e_woAck_bss2(c)]);
    lat_occur(index) = lat_occur(index)+1;
end

avg_lat = avg_lat_container./lat_occur;

time_axis = 0:0.5:floor(time_bss2(end)*2)/2;


figure(14)
hold on
yyaxis left
semilogy(time_axis,avg_lat./1e3,'Color',[0.3 0.75 0.93],'Marker','none','LineStyle','-')
hold on
semilogy(time_axis,min_lat./1e3,'Color',[0.3 0.75 0.93],'Marker','none','LineStyle','--')
semilogy(time_axis,max_lat./1e3,'LineStyle','-.','Color',[0.3 0.75 0.93],'Marker','none','LineStyle','-.')
hold off
ylabel('Latency w/o Ack [ms] [0.5s window]')

yyaxis right
hold on
plot(tput_time_bss2,tput_bss2./1e6,'Color',[0.93 0.70 0.13],'LineStyle','-')
grid on
hold off
xlabel('time [s] or distance [m]')
ylabel('Throughput [Mbps] [0.5s average]')
legend('avg BSS1','min BSS1','max BSS1','avg BSS2','min BSS2','max BSS2','Tput BSS1','Tput BSS2')

hold off
