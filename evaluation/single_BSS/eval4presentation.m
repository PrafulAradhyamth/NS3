clear all
close all
clc


%% EVAL
filen = 'test_new_all_results.mat';
load(filen)

figure(6)
yyaxis left
plot(results.MCS.time,results.MCS.data,'Marker','o','LineStyle','none')
ylabel('MCS')
set(gca,'YTick',0:7)

yyaxis right
plot(results.tput.time,results.tput.data./1e6)
ylabel('Throughput [Mbps] [0.5s average]')

grid on
xlabel('time [s] or distance [m]')

min_lim = 100;
max_lim = 200;

% min_lim = 70000;
% max_lim = 75000;

xaxis = results.latency.xaxis;
yaxis = results.latency.congestion.data./1e-6;

figure(1)
plot(xaxis(min_lim:max_lim),yaxis(min_lim:max_lim),'Marker','x','LineStyle','none')
grid on

xlabel('sequence number')
ylabel('congestion latency [탎]')

%%

xaxis = results.latency.xaxis;
yaxis = results.latency.aggregation.data./1e-6;

figure(2)
plot(xaxis(min_lim:max_lim),yaxis(min_lim:max_lim),'Marker','x','LineStyle','none')
grid on

xlabel('sequence number')
ylabel('aggregation latency [탎]')

%%

xaxis = results.latency.xaxis;
yaxis = results.latency.firstTX.data./1e-6;

figure(3)
plot(xaxis(min_lim:max_lim),yaxis(min_lim:max_lim),'Marker','x','LineStyle','none')
grid on

xlabel('sequence number')
ylabel('transmission latency [탎]')


%%

xaxis = results.latency.xaxis;
yaxis = results.latency.ack.data./1e-6;

figure(4)
plot(xaxis(min_lim:max_lim),yaxis(min_lim:max_lim),'Marker','x','LineStyle','none')
grid on

xlabel('sequence number')
ylabel('Ack latency [탎]')


%%

xaxis = results.latency.xaxis;
yaxis = results.latency.retry.data./1e-6;

figure(5)
plot(xaxis(min_lim:max_lim),yaxis(min_lim:max_lim),'Marker','x','LineStyle','none')
grid on

xlabel('sequence number')
ylabel('retry latency [탎]')

%% PLOT HISTOGRAMS
fig=figure; set(fig,'visible','off');
hist_congestion_lat_x = [0:20:400  1200:20:1600 inf];
hist_h = histogram(results.latency.congestion.data(min_lim:max_lim)./1e-6,hist_congestion_lat_x);
hist_congestion_lat_x = hist_congestion_lat_x(1:end-1);
hist_congestion_lat = hist_h.Values;
close(fig);

fig=figure; set(fig,'visible','off');
hist_aggregation_lat_x = [0:500:5000 inf];
hist_h = histogram(results.latency.aggregation.data(min_lim:max_lim)./1e-6,hist_aggregation_lat_x);
hist_aggregation_lat_x = hist_aggregation_lat_x(1:end-1);
hist_aggregation_lat = hist_h.Values;
close(fig);

fig=figure; set(fig,'visible','off');
hist_firstTx_lat_x = [0:20:1000 inf];
hist_h = histogram(results.latency.firstTX.data(min_lim:max_lim)./1e-6,hist_firstTx_lat_x);
hist_firstTx_lat_x = hist_firstTx_lat_x(1:end-1);
hist_firstTx_lat = hist_h.Values;
close(fig);

fig=figure; set(fig,'visible','off');
hist_ack_lat_x = [0:500:5500 inf];
hist_h = histogram(results.latency.ack.data(min_lim:max_lim)./1e-6,hist_ack_lat_x);
hist_ack_lat_x = hist_ack_lat_x(1:end-1);
hist_ack_lat = hist_h.Values;
close(fig);

fig=figure; set(fig,'visible','off');
hist_retry_lat_x = [0:20:1000 inf];
hist_h = histogram(results.latency.retry.data(min_lim:max_lim)./1e-6,hist_retry_lat_x);
hist_retry_lat_x = hist_retry_lat_x(1:end-1);
hist_retry_lat = hist_h.Values;
close(fig);




figure(10)
plot(hist_congestion_lat_x,hist_congestion_lat./sum(hist_congestion_lat))
hold on
plot(hist_aggregation_lat_x,hist_aggregation_lat./sum(hist_aggregation_lat))
plot(hist_firstTx_lat_x,hist_firstTx_lat./sum(hist_firstTx_lat))
plot(hist_ack_lat_x,hist_ack_lat./sum(hist_ack_lat))
plot(hist_retry_lat_x,hist_retry_lat./sum(hist_retry_lat),'LineStyle','-.')


hold off
grid on
xlabel('latency [탎]')
ylabel('relative occurrence')
legend('Congestion','Aggregation','Transmit','Ack','Retry')


xlimits = xlim;
% xlim([0 1600])


%%
figure(11)

xaxis = results.latency.xaxis;
yaxis = results.latency.congestion.data./1e-6;
plot(xaxis(min_lim:max_lim),yaxis(min_lim:max_lim),'Marker','v','LineStyle','none')
hold on
xaxis = results.latency.xaxis;
yaxis = results.latency.aggregation.data./1e-6;
plot(xaxis(min_lim:max_lim),yaxis(min_lim:max_lim),'Marker','s','LineStyle','none')
xaxis = results.latency.xaxis;
yaxis = results.latency.firstTX.data./1e-6;
plot(xaxis(min_lim:max_lim),yaxis(min_lim:max_lim),'Marker','x','LineStyle','none')
xaxis = results.latency.xaxis;
yaxis = results.latency.ack.data./1e-6;
plot(xaxis(min_lim:max_lim),yaxis(min_lim:max_lim),'Marker','d','LineStyle','none')
xaxis = results.latency.xaxis;
yaxis = results.latency.retry.data./1e-6;
plot(xaxis(min_lim:max_lim),yaxis(min_lim:max_lim),'Marker','o','LineStyle','none')


hold off
grid on

xlabel('Sequence number')
ylabel('Latency [탎]')
legend('Congestion','Aggregation','Transmit','Ack','Retry')


%%
lat_noAck = results.latency.congestion.data./1e-6 + results.latency.aggregation.data./1e-6 + results.latency.retry.data./1e-6;
lat_ack = results.latency.congestion.data./1e-6 + results.latency.aggregation.data./1e-6 + results.latency.firstTX.data./1e-6 + results.latency.ack.data./1e-6;

figure(12)
plot(xaxis(min_lim:max_lim),lat_noAck(min_lim:max_lim),'Marker','v','LineStyle','none')
hold on
plot(xaxis(min_lim:max_lim),lat_ack(min_lim:max_lim),'Marker','s','LineStyle','none')
hold off
grid on

xlabel('Sequence number')
ylabel('End-to-end latency [탎]')
legend('w/o Ack','w/ Ack')

%%


figure(13)
plot(xaxis,lat_noAck,'Marker','v','LineStyle','none')
hold on
plot(xaxis,lat_ack,'Marker','s','LineStyle','none')
hold off
grid on

xlabel('Sequence number')
ylabel('End-to-end latency [탎]')
legend('w/o Ack','w/ Ack')
%%
xaxis = results.latency.xaxis;
time = results.latency.time;
time = time-time(1);

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

figure(14)
yyaxis left
semilogy(time_axis,avg_lat./1e3)
hold on
semilogy(time_axis,min_lat./1e3)
semilogy(time_axis,max_lat./1e3,'LineStyle','-.')
hold off
ylabel('Latency w/o Ack [ms] [0.5s window]')

yyaxis right
plot(results.tput.time,results.tput.data./1e6)
grid on
xlabel('time [s] or distance [m]')
ylabel('Throughput [Mbps] [0.5s average]')
legend('avg','min','max')
