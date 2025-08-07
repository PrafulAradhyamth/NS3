clear all
close all
clc


%% EVAL
filenA = 'highSensRetryOnce_results.mat';
filenB = 'highSensRetryOnce_bestProbUpdate_results.mat';
a = load(filenA);
b = load(filenB);

%% MCS and throughput
figure(1)
yyaxis left
plot(a.results.MCS.time,a.results.MCS.data,'Marker','o','LineStyle','none')
hold on
plot(b.results.MCS.time,b.results.MCS.data,'Marker','x','LineStyle','none','Color',[0.467 0.675 0.188])
hold off
ylabel('MCS')
set(gca,'YTick',0:7)

yyaxis right
plot(a.results.tput.time,a.results.tput.data./1e6)
hold on
plot(b.results.tput.time,b.results.tput.data./1e6,'LineStyle','--')
hold off
ylabel('Throughput [Mbps] [0.5s average]')

grid on
xlabel('time [s] or distance [m]')
legend('minstrel HT','minstrel HT+','minstrel HT','minstrel HT+')

%% min/avg/max latency
xaxis = a.results.latency.xaxis;
time = a.results.latency.time;
time = time-time(1);
lat_noAck = a.results.latency.congestion.data./1e-6 + a.results.latency.aggregation.data./1e-6 + a.results.latency.retry.data./1e-6;


avg_lat_container = zeros(ceil(time(end)*2),1);
min_lat = inf.*ones(ceil(time(end)*2),1);
max_lat = zeros(ceil(time(end)*2),1);
lat_occur = zeros(ceil(time(end)*2),1);


for c = xaxis(1):xaxis(end)
    index = floor(time(c)*2)+1;
    avg_lat_container(index) = avg_lat_container(index) + lat_noAck(c);
    min_lat(index) = min([min_lat(index) lat_noAck(c)]);
    max_lat(index) = max([max_lat(index) lat_noAck(c)]);
    lat_occur(index) = lat_occur(index)+1;
end

avg_lat = avg_lat_container./lat_occur;

time_axis = 0:0.5:floor(time(end)*2)/2;

figure(2)
yyaxis left
semilogy(time_axis,avg_lat./1e3)
hold on
semilogy(time_axis,min_lat./1e3)
semilogy(time_axis,max_lat./1e3,'LineStyle','-.')
hold off
ylabel('Latency w/o Ack [ms] [0.5s window]')


xaxis = b.results.latency.xaxis;
time = b.results.latency.time;
time = time-time(1);
lat_noAck = b.results.latency.congestion.data./1e-6 + b.results.latency.aggregation.data./1e-6 + b.results.latency.retry.data./1e-6;

avg_lat_container = zeros(ceil(time(end)*2),1);
min_lat = inf.*ones(ceil(time(end)*2),1);
max_lat = zeros(ceil(time(end)*2),1);
lat_occur = zeros(ceil(time(end)*2),1);

for c = xaxis(1):xaxis(end)
    index = floor(time(c)*2)+1;
    avg_lat_container(index) = avg_lat_container(index) + lat_noAck(c);
    min_lat(index) = min([min_lat(index) lat_noAck(c)]);
    max_lat(index) = max([max_lat(index) lat_noAck(c)]);
    lat_occur(index) = lat_occur(index)+1;
end

avg_lat = avg_lat_container./lat_occur;

time_axis = 0:0.5:floor(time(end)*2)/2;

hold on
semilogy(time_axis,avg_lat./1e3,'LineStyle','-','Color',[0.467 0.675 0.188])
semilogy(time_axis,min_lat./1e3,'LineStyle','--','Marker','none','Color',[0.467 0.675 0.188])
semilogy(time_axis,max_lat./1e3,'LineStyle','-.','Marker','none','Color',[0.467 0.675 0.188])
hold off


yyaxis right
plot(a.results.tput.time,a.results.tput.data./1e6,'LineStyle','-')
hold on
plot(b.results.tput.time,b.results.tput.data./1e6,'LineStyle','-','Color',[0.929 0.694 0.125])
hold off
grid on
xlabel('time [s] or distance [m]')
ylabel('Throughput [Mbps] [0.5s average]')
legend('avg','min','max')

% title('blue/red: minstrel HT | green/orange: minstrel HT+')
title('blue/red: a)+b) | green/orange: a)+b)+d)')


%% Retry vs. sequence number
figure(3)
plot(a.results.retry.perSeqNum.xaxis,a.results.retry.perSeqNum.data)
hold on
plot(b.results.retry.perSeqNum.xaxis,b.results.retry.perSeqNum.data)
line([1.83e5 1.83e5],[0 16],'LineStyle','--')
% line([1.9e5 1.9e5],[0 16],'LineStyle','--')
line([1.9e5 1.9e5],[0 16],'LineStyle','--','Color',[0.85 0.325 0.098])
hold off
grid on
xlabel('Sequence number')
ylabel('Number of retries')
legend('Minstrel HT','Minstrel HT+','90s limit','90s limit')

%% Retry vs. sequence number PDF
fig=figure; set(fig,'visible','off');
hist_retry_a_x_all = [0:20];
hist_h = histogram(a.results.retry.perSeqNum.data,hist_retry_a_x_all);
hist_retry_a_x_all = hist_retry_a_x_all(1:end-1);
hist_retry_a_all = hist_h.Values;
close(fig);

fig=figure; set(fig,'visible','off');
hist_retry_b_x_all = [0:20];
hist_h = histogram(b.results.retry.perSeqNum.data,hist_retry_b_x_all);
hist_retry_b_x_all = hist_retry_b_x_all(1:end-1);
hist_retry_b_all = hist_h.Values;
close(fig);

% max_seqNum = 1.83e5;
max_seqNum = 1.9e5;
tmp = a.results.retry.perSeqNum.xaxis-max_seqNum;
ind_max_seqNum = find(tmp>0);
ind_max_seqNum = ind_max_seqNum(1);

fig=figure; set(fig,'visible','off');
hist_retry_a_x_part = [0:20];
hist_h = histogram(a.results.retry.perSeqNum.data(1:ind_max_seqNum),hist_retry_a_x_part);
hist_retry_a_x_part = hist_retry_a_x_part(1:end-1);
hist_retry_a_part = hist_h.Values;
close(fig);

max_seqNum = 1.9e5;
tmp = b.results.retry.perSeqNum.xaxis-max_seqNum;
ind_max_seqNum = find(tmp>0);
ind_max_seqNum = ind_max_seqNum(1);

fig=figure; set(fig,'visible','off');
hist_retry_b_x_part = [0:20];
hist_h = histogram(b.results.retry.perSeqNum.data(1:ind_max_seqNum),hist_retry_b_x_part);
hist_retry_b_x_part = hist_retry_b_x_part(1:end-1);
hist_retry_b_part = hist_h.Values;
close(fig);

figure(4)
semilogy(hist_retry_a_x_all,hist_retry_a_all./sum(hist_retry_a_all),'Marker','o')
hold on
semilogy(hist_retry_b_x_all,hist_retry_b_all./sum(hist_retry_b_all),'Marker','x')

semilogy(hist_retry_a_x_part,hist_retry_a_part./sum(hist_retry_a_part),'Marker','o')
semilogy(hist_retry_b_x_part,hist_retry_b_part./sum(hist_retry_b_part),'Marker','x')
hold off
grid on
xlabel('Number of retransmissions')
ylabel('Probability')
% legend('Minstrel HT [all]','Minstrel HT+ [all]','Minstrel HT [until 90s limit]','Minstrel HT+ [until 90s limit]')
legend('a)+b) [all]','a)+b)+d) [all]','a)+b) [until 90s limit]','a)+b)+d) [until 90s limit]')

%% latency PDF
lat_noAck = a.results.latency.congestion.data./1e-6 + a.results.latency.aggregation.data./1e-6 + a.results.latency.retry.data./1e-6;

fig=figure; set(fig,'visible','off');
hist_lat_a_x_all = [0:100:30000];
hist_h = histogram(lat_noAck(1:1.5e5),hist_lat_a_x_all);
hist_lat_a_x_all = hist_lat_a_x_all(1:end-1);
hist_lat_a_all = hist_h.Values;
close(fig);

lat_noAck = b.results.latency.congestion.data./1e-6 + b.results.latency.aggregation.data./1e-6 + b.results.latency.retry.data./1e-6;
fig=figure; set(fig,'visible','off');
hist_lat_b_x_all = [0:100:30000];
hist_h = histogram(lat_noAck(1:1.5e5),hist_lat_b_x_all);
hist_lat_b_x_all = hist_lat_b_x_all(1:end-1);
hist_lat_b_all = hist_h.Values;
close(fig);

figure(5)
semilogy(hist_lat_a_x_all,hist_lat_a_all./sum(hist_lat_a_all))
hold on
semilogy(hist_lat_b_x_all,hist_lat_b_all./sum(hist_lat_b_all))
hold off
grid on
legend('Minstrel HT','Minstrel HT+')
xlabel('latency [탎]')
ylabel('Probability')

%% aggregation size
figure(6)
yyaxis left
plot(a.results.tput.time,a.results.tput.data./1e6)
hold on
plot(b.results.tput.time,b.results.tput.data./1e6,'LineStyle','--')
hold off
ylabel('Throughput [Mbps] [0.5s average]')

yyaxis right
plot(a.results.AMPDU_size.time,a.results.AMPDU_size.data,'Marker','o','LineStyle','none')
hold on
plot(b.results.AMPDU_size.time,b.results.AMPDU_size.data,'Marker','x','LineStyle','none','Color',[0.467 0.675 0.188])
hold off
ylabel('Aggregation size')


grid on
xlabel('time [s] or distance [m]')
legend('minstrel HT','minstrel HT+','minstrel HT','minstrel HT+')

figure(6)


% %%
% min_lim = 1;
% % max_lim = 200;
% 
% % min_lim = 70000;
% max_lim = 70000;
% 
% xaxis = results.latency.xaxis;
% yaxis = results.latency.congestion.data./1e-6;
% 
% figure(1)
% plot(xaxis(min_lim:max_lim),yaxis(min_lim:max_lim),'Marker','x','LineStyle','none')
% grid on
% 
% xlabel('sequence number')
% ylabel('congestion latency [탎]')
% 
% %%
% 
% xaxis = results.latency.xaxis;
% yaxis = results.latency.aggregation.data./1e-6;
% 
% figure(2)
% plot(xaxis(min_lim:max_lim),yaxis(min_lim:max_lim),'Marker','x','LineStyle','none')
% grid on
% 
% xlabel('sequence number')
% ylabel('aggregation latency [탎]')
% 
% %%
% 
% xaxis = results.latency.xaxis;
% yaxis = results.latency.firstTX.data./1e-6;
% 
% figure(3)
% plot(xaxis(min_lim:max_lim),yaxis(min_lim:max_lim),'Marker','x','LineStyle','none')
% grid on
% 
% xlabel('sequence number')
% ylabel('transmission latency [탎]')
% 
% 
% %%
% 
% xaxis = results.latency.xaxis;
% yaxis = results.latency.ack.data./1e-6;
% 
% figure(4)
% plot(xaxis(min_lim:max_lim),yaxis(min_lim:max_lim),'Marker','x','LineStyle','none')
% grid on
% 
% xlabel('sequence number')
% ylabel('Ack latency [탎]')
% 
% 
% %%
% 
% xaxis = results.latency.xaxis;
% yaxis = results.latency.retry.data./1e-6;
% 
% figure(5)
% plot(xaxis(min_lim:max_lim),yaxis(min_lim:max_lim),'Marker','x','LineStyle','none')
% grid on
% 
% xlabel('sequence number')
% ylabel('retry latency [탎]')
% 
% %% PLOT HISTOGRAMS
% fig=figure; set(fig,'visible','off');
% hist_congestion_lat_x = [0:20:400  1200:20:1600 inf];
% hist_h = histogram(results.latency.congestion.data(min_lim:max_lim)./1e-6,hist_congestion_lat_x);
% hist_congestion_lat_x = hist_congestion_lat_x(1:end-1);
% hist_congestion_lat = hist_h.Values;
% close(fig);
% 
% fig=figure; set(fig,'visible','off');
% hist_aggregation_lat_x = [0:500:5000 inf];
% hist_h = histogram(results.latency.aggregation.data(min_lim:max_lim)./1e-6,hist_aggregation_lat_x);
% hist_aggregation_lat_x = hist_aggregation_lat_x(1:end-1);
% hist_aggregation_lat = hist_h.Values;
% close(fig);
% 
% fig=figure; set(fig,'visible','off');
% hist_firstTx_lat_x = [0:20:1000 inf];
% hist_h = histogram(results.latency.firstTX.data(min_lim:max_lim)./1e-6,hist_firstTx_lat_x);
% hist_firstTx_lat_x = hist_firstTx_lat_x(1:end-1);
% hist_firstTx_lat = hist_h.Values;
% close(fig);
% 
% fig=figure; set(fig,'visible','off');
% hist_ack_lat_x = [0:500:5500 inf];
% hist_h = histogram(results.latency.ack.data(min_lim:max_lim)./1e-6,hist_ack_lat_x);
% hist_ack_lat_x = hist_ack_lat_x(1:end-1);
% hist_ack_lat = hist_h.Values;
% close(fig);
% 
% fig=figure; set(fig,'visible','off');
% hist_retry_lat_x = [0:20:1000 inf];
% hist_h = histogram(results.latency.retry.data(min_lim:max_lim)./1e-6,hist_retry_lat_x);
% hist_retry_lat_x = hist_retry_lat_x(1:end-1);
% hist_retry_lat = hist_h.Values;
% close(fig);
% 
% 
% 
% 
% figure(10)
% plot(hist_congestion_lat_x,hist_congestion_lat./sum(hist_congestion_lat))
% hold on
% plot(hist_aggregation_lat_x,hist_aggregation_lat./sum(hist_aggregation_lat))
% plot(hist_firstTx_lat_x,hist_firstTx_lat./sum(hist_firstTx_lat))
% plot(hist_ack_lat_x,hist_ack_lat./sum(hist_ack_lat))
% plot(hist_retry_lat_x,hist_retry_lat./sum(hist_retry_lat),'LineStyle','-.')
% 
% 
% hold off
% grid on
% xlabel('latency [탎]')
% ylabel('relative occurrence')
% legend('Congestion','Aggregation','Transmit','Ack','Retry')
% 
% 
% xlimits = xlim;
% % xlim([0 1600])
% 
% 
% %%
% figure(11)
% 
% xaxis = results.latency.xaxis;
% yaxis = results.latency.congestion.data./1e-6;
% plot(xaxis(min_lim:max_lim),yaxis(min_lim:max_lim),'Marker','v','LineStyle','none')
% hold on
% xaxis = results.latency.xaxis;
% yaxis = results.latency.aggregation.data./1e-6;
% plot(xaxis(min_lim:max_lim),yaxis(min_lim:max_lim),'Marker','s','LineStyle','none')
% xaxis = results.latency.xaxis;
% yaxis = results.latency.firstTX.data./1e-6;
% plot(xaxis(min_lim:max_lim),yaxis(min_lim:max_lim),'Marker','x','LineStyle','none')
% xaxis = results.latency.xaxis;
% yaxis = results.latency.ack.data./1e-6;
% plot(xaxis(min_lim:max_lim),yaxis(min_lim:max_lim),'Marker','d','LineStyle','none')
% xaxis = results.latency.xaxis;
% yaxis = results.latency.retry.data./1e-6;
% plot(xaxis(min_lim:max_lim),yaxis(min_lim:max_lim),'Marker','o','LineStyle','none')
% 
% 
% hold off
% grid on
% 
% xlabel('Sequence number')
% ylabel('Latency [탎]')
% legend('Congestion','Aggregation','Transmit','Ack','Retry')
% 
% 
% %%
% lat_noAck = results.latency.congestion.data./1e-6 + results.latency.aggregation.data./1e-6 + results.latency.retry.data./1e-6;
% lat_ack = results.latency.congestion.data./1e-6 + results.latency.aggregation.data./1e-6 + results.latency.firstTX.data./1e-6 + results.latency.ack.data./1e-6;
% 
% figure(12)
% plot(xaxis(min_lim:max_lim),lat_noAck(min_lim:max_lim),'Marker','v','LineStyle','none')
% hold on
% plot(xaxis(min_lim:max_lim),lat_ack(min_lim:max_lim),'Marker','s','LineStyle','none')
% hold off
% grid on
% 
% xlabel('Sequence number')
% ylabel('End-to-end latency [탎]')
% legend('w/o Ack','w/ Ack')
% 
% %%
% 
% 
% figure(13)
% plot(xaxis,lat_noAck,'Marker','v','LineStyle','none')
% hold on
% plot(xaxis,lat_ack,'Marker','s','LineStyle','none')
% hold off
% grid on
% 
% xlabel('Sequence number')
% ylabel('End-to-end latency [탎]')
% legend('w/o Ack','w/ Ack')


