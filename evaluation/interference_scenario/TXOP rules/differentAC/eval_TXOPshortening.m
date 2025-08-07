clear all
close all
clc


%% EVAL
filen = 'ap2_results_TXOPshortening.mat';
% filen = 'BSS1_TXOPcontentRestriction_results.mat';
load(filen)

min_lim = 1;
% max_lim = 200;

% min_lim = 70000;
max_lim = 172512;%95000;


%%

xaxis = results.latency.xaxis;
yaxis = results.latency.retry.data./1e-6;
y2axis = results.latency.retry.TXOPshortening_data./1e-6;

figure(5)
plot(xaxis(min_lim:max_lim),yaxis(min_lim:max_lim),'Marker','x','LineStyle','none')
hold on
plot(xaxis(min_lim:max_lim),yaxis(min_lim:max_lim)-y2axis(min_lim:max_lim),'Marker','o','LineStyle','none')
grid on
hold off

xlabel('sequence number')
ylabel('retry latency [탎]')

%% PLOT HISTOGRAMS
fig=figure; set(fig,'visible','off');
% hist_congestion_lat_x = [0:20000 inf]; %[0:20:400  1200:20:1600 inf];
% hist_congestion_lat_x = [0:10:200 300:200:1300 1400:10:1600 1700:200:5300 5440:10:5640 5700:200:6700 6850:10:7050 7200:200:10800 10900:10:11100 11200:200:12200 12300:10:12500 12600:200:16200 16300:10:16500 16600:200:17600 17700:10:17900 18000:200:20000 inf]; %[0:20:400  1200:20:1600 inf];
% hist_congestion_lat_x = [0:10:200 300:200:1300 1400:10:1600 1700:200:5300 5440:10:5640 5700:200:6700 6850:10:7050 7200:200:10800 10900:10:11100 11200:200:12200 12300:10:12500 12600:200:16200 inf]; %[0:20:400  1200:20:1600 inf];
hist_congestion_lat_x = [0:20000 inf];
hist_h = histogram(results.latency.congestion.data(min_lim:max_lim)./1e-6,hist_congestion_lat_x,'Normalization','cdf');
hist_congestion_lat_x = hist_congestion_lat_x(1:end-1);
hist_congestion_lat = hist_h.Values;
close(fig);

fig=figure; set(fig,'visible','off');
% hist_aggregation_lat_x = [0:500:6000 inf];
hist_aggregation_lat_x = [0:20000 inf];
hist_h = histogram(results.latency.aggregation.data(min_lim:max_lim)./1e-6,hist_aggregation_lat_x,'Normalization','cdf');
hist_aggregation_lat_x = hist_aggregation_lat_x(1:end-1);
hist_aggregation_lat = hist_h.Values;
close(fig);

fig=figure; set(fig,'visible','off');
% hist_firstTx_lat_x = [180:20:250 inf];
hist_firstTx_lat_x = [0:20000 inf];
hist_h = histogram(results.latency.firstTX.data(min_lim:max_lim)./1e-6,hist_firstTx_lat_x,'Normalization','cdf');
hist_firstTx_lat_x = hist_firstTx_lat_x(1:end-1);
hist_firstTx_lat = hist_h.Values;
close(fig);

fig=figure; set(fig,'visible','off');
% hist_ack_lat_x = [0:500:6000 inf];
hist_ack_lat_x = [0:20000 inf];
hist_h = histogram(results.latency.ack.data(min_lim:max_lim)./1e-6,hist_ack_lat_x,'Normalization','cdf');
hist_ack_lat_x = hist_ack_lat_x(1:end-1);
hist_ack_lat = hist_h.Values;
close(fig);

fig=figure; set(fig,'visible','off');
% hist_retry_lat_x = [0:20:20000 inf];
% hist_retry_lat_x = [180:20:250 400:100:5600 5700:20:8600 8700:100:11200 11300:20:14100 14200:100:15000 inf];
hist_retry_lat_x = [0:20000 inf];
hist_h = histogram(results.latency.retry.data(min_lim:max_lim)./1e-6,hist_retry_lat_x,'Normalization','cdf');
hist_retry_lat_x = hist_retry_lat_x(1:end-1);
hist_retry_lat = hist_h.Values;
close(fig);

fig=figure; set(fig,'visible','off');
% hist_retry_lat_x = [0:20:20000 inf];
% hist_retry_lat_x = [180:20:250 400:100:5600 5700:20:8600 8700:100:11200 11300:20:14100 14200:100:15000 inf];
hist_retry_cor_lat_x = [0:20000 inf];
hist_h = histogram(results.latency.retry.data(min_lim:max_lim)./1e-6 - results.latency.retry.TXOPshortening_data(min_lim:max_lim)./1e-6 ,hist_retry_cor_lat_x,'Normalization','cdf');
hist_retry_cor_lat_x = hist_retry_cor_lat_x(1:end-1);
hist_retry_cor_lat = hist_h.Values;
close(fig);




figure(10)
% plot(hist_congestion_lat_x,hist_congestion_lat./sum(hist_congestion_lat))
% hold on
% plot(hist_aggregation_lat_x,hist_aggregation_lat./sum(hist_aggregation_lat))
% plot(hist_firstTx_lat_x,hist_firstTx_lat./sum(hist_firstTx_lat))
% plot(hist_ack_lat_x,hist_ack_lat./sum(hist_ack_lat))
% plot(hist_retry_lat_x,hist_retry_lat./sum(hist_retry_lat),'LineStyle','-')

plot(hist_congestion_lat_x,hist_congestion_lat)
hold on
plot(hist_aggregation_lat_x,hist_aggregation_lat)
plot(hist_firstTx_lat_x,hist_firstTx_lat)
plot(hist_ack_lat_x,hist_ack_lat)
plot(hist_retry_lat_x,hist_retry_lat)
plot(hist_retry_cor_lat_x,hist_retry_cor_lat)



hold off
grid on
xlabel('latency [탎]')
ylabel('CDF')
legend('Congestion','Aggregation','Transmit','Ack','Retry','Retry w/ TXOP shortening','Location','SouthEast')


xlimits = xlim;
% xlim([0 14000])


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
xaxis = results.latency.xaxis;
yaxis = results.latency.retry.data./1e-6 - results.latency.retry.TXOPshortening_data./1e-6;
plot(xaxis(min_lim:max_lim),yaxis(min_lim:max_lim),'Marker','h','LineStyle','none')


hold off
grid on

xlabel('Sequence number')
ylabel('Latency [탎]')
legend('Congestion','Aggregation','Transmit','Ack','Retry','Retry w/ shortening','Location','NorthWest')


%%
lat_noAck = results.latency.congestion.data./1e-6 + results.latency.aggregation.data./1e-6 + results.latency.retry.data./1e-6;
lat_ack = results.latency.congestion.data./1e-6 + results.latency.aggregation.data./1e-6 + results.latency.retry.data./1e-6 + results.latency.ack.data./1e-6;

lat_noAck_wShort = results.latency.congestion.data./1e-6 + results.latency.aggregation.data./1e-6 + results.latency.retry.data./1e-6 - results.latency.retry.TXOPshortening_data./1e-6;
lat_ack_wShort = results.latency.congestion.data./1e-6 + results.latency.aggregation.data./1e-6 + results.latency.retry.data./1e-6 + results.latency.ack.data./1e-6 - results.latency.retry.TXOPshortening_data./1e-6;

figure(12)
plot(xaxis(min_lim:max_lim),lat_noAck(min_lim:max_lim),'Marker','v','LineStyle','none')
hold on
plot(xaxis(min_lim:max_lim),lat_ack(min_lim:max_lim),'Marker','s','LineStyle','none')
plot(xaxis(min_lim:max_lim),lat_noAck_wShort(min_lim:max_lim),'Marker','x','LineStyle','none')
plot(xaxis(min_lim:max_lim),lat_ack_wShort(min_lim:max_lim),'Marker','d','LineStyle','none')
hold off
grid on

xlabel('Sequence number')
ylabel('End-to-end latency [탎]')
legend('w/o Ack','w/ Ack','w/o Ack w/ shortening','w/ Ack w/ shortening')


fig=figure; set(fig,'visible','off');
hist_lat_noAck_x = [0:50e3 inf];
hist_h = histogram(lat_noAck(min_lim:max_lim),hist_lat_noAck_x,'Normalization','cdf');
hist_lat_noAck_x = hist_lat_noAck_x(1:end-1);
hist_lat_noAck = hist_h.Values;
close(fig);

fig=figure; set(fig,'visible','off');
hist_lat_ack_x = [0:50e3 inf];
hist_h = histogram(lat_ack(min_lim:max_lim),hist_lat_ack_x,'Normalization','cdf');
hist_lat_ack_x = hist_lat_ack_x(1:end-1);
hist_lat_ack = hist_h.Values;
close(fig);

fig=figure; set(fig,'visible','off');
hist_lat_noAck_wShort_x = [0:50e3 inf];
hist_h = histogram(lat_noAck_wShort(min_lim:max_lim),hist_lat_noAck_wShort_x,'Normalization','cdf');
hist_lat_noAck_wShort_x = hist_lat_noAck_wShort_x(1:end-1);
hist_lat_noAck_wShort = hist_h.Values;
close(fig);

fig=figure; set(fig,'visible','off');
hist_lat_ack_wShort_x = [0:50e3 inf];
hist_h = histogram(lat_ack_wShort(min_lim:max_lim),hist_lat_ack_wShort_x,'Normalization','cdf');
hist_lat_ack_wShort_x = hist_lat_ack_wShort_x(1:end-1);
hist_lat_ack_wShort = hist_h.Values;
close(fig);


figure(13)
plot(hist_lat_noAck_x,hist_lat_noAck)
hold on
plot(hist_lat_ack_x,hist_lat_ack)
plot(hist_lat_noAck_wShort_x,hist_lat_noAck_wShort)
plot(hist_lat_ack_wShort_x,hist_lat_ack_wShort)

hold off
grid on
xlabel('End-to-end latency [탎]')
ylabel('CDF')
lh = legend('w/o Ack','w/ Ack','w/o Ack w/ TXOP shortening','w/ Ack w/ TXOP shortening');
set(lh,'Location','SouthEast');
set(get(gca,'XAxis'),'Exponent',3)

% xlimits = xlim;
% xlim([0 14000])


%%
xaxis = results.latency.xaxis+1;
time = results.latency.time;
time = time-time(1);

pdf_res = 11;

avg_lat_container = zeros(ceil(time(end)*2),1);
avg_lat_container_wShort = zeros(ceil(time(end)*2),1);
min_lat = inf.*ones(ceil(time(end)*2),1);
min_lat_wShort = inf.*ones(ceil(time(end)*2),1);
max_lat = zeros(ceil(time(end)*2),1);
max_lat_wShort = zeros(ceil(time(end)*2),1);

lat_occur = zeros(ceil(time(end)*2),1);

lat_pdf = zeros(ceil(time(end)*2),pdf_res);

for c = xaxis(1):xaxis(end)
    index = floor(time(c)*2)+1;
    avg_lat_container(index) = avg_lat_container(index) + lat_noAck(c);
    avg_lat_container_wShort(index) = avg_lat_container_wShort(index) + lat_noAck_wShort(c);
    min_lat(index) = min([min_lat(index) lat_noAck(c)]);
    min_lat_wShort(index) = min([min_lat_wShort(index) lat_noAck_wShort(c)]);
    max_lat(index) = max([max_lat(index) lat_noAck(c)]);
    max_lat_wShort(index) = max([max_lat_wShort(index) lat_noAck_wShort(c)]);
    lat_occur(index) = lat_occur(index)+1;
end

avg_lat = avg_lat_container./lat_occur;
avg_lat_wShort = avg_lat_container_wShort./lat_occur;

time_axis = 0:0.5:floor(time(end)*2)/2;

figure(14)
yyaxis left
semilogy(time_axis,avg_lat./1e3)
hold on
semilogy(time_axis,min_lat./1e3,'LineStyle','--')
semilogy(time_axis,max_lat./1e3,'LineStyle','-.')
semilogy(time_axis,avg_lat_wShort./1e3,'LineStyle','-','Marker','none','Color',[0.078 0.169 0.549])
semilogy(time_axis,min_lat_wShort./1e3,'LineStyle','--','Marker','none','Color',[0.078 0.169 0.549])
semilogy(time_axis,max_lat_wShort./1e3,'LineStyle','-.','Marker','none','Color',[0.078 0.169 0.549])
hold off
ylabel('Latency w/o Ack [ms] [0.5s window]')

yyaxis right
plot(results.tput.time,results.tput.data./1e6)
grid on
xlabel('time [s] or distance [m]')
ylabel('Throughput [Mbps] [0.5s average]')
legend('avg','min','max','avg w/ shortening','min w/ shortening','max w/ shortening')
%%
percentile = [0.5 0.9 0.95 0.99];

percentile_val = zeros(4,length(percentile));

for c = 1:size(percentile_val,2)
    ind = find(hist_lat_noAck>percentile(c));
    if ~isempty(ind)
        percentile_val(1,c) = hist_lat_noAck_x(ind(1));
    end
end

for c = 1:size(percentile_val,2)
    ind = find(hist_lat_noAck_wShort>percentile(c));
    if ~isempty(ind)
        percentile_val(2,c) = hist_lat_noAck_wShort_x(ind(1));
    end
end

for c = 1:size(percentile_val,2)
    ind = find(hist_lat_ack>percentile(c));
    if ~isempty(ind)
        percentile_val(3,c) = hist_lat_ack_x(ind(1));
    end
end
for c = 1:size(percentile_val,2)
    ind = find(hist_lat_ack_wShort>percentile(c));
    if ~isempty(ind)
        percentile_val(4,c) = hist_lat_ack_wShort_x(ind(1));
    end
end

figure(15)
bar(percentile_val.'./1e3)
set(gca,'XTick',1:length(percentile));
set(gca,'XTickLabel',percentile*100);
ylabel('end-to-end latency [ms]')
xlabel('Percentile');
lh = legend('w/o Ack w/o shortening', 'w/o Ack w/ shortening', 'w/ Ack w/o shortening', 'w/ Ack w/ shortening');
set(lh,'Location','NorthWest')
grid on

percentile_delta_val = [percentile_val(1,:)-percentile_val(2,:);percentile_val(3,:)-percentile_val(4,:)];

figure(16)
bar(percentile_delta_val.'./1e3)
set(gca,'XTick',1:length(percentile));
set(gca,'XTickLabel',percentile*100);
ylabel('Gain of TXOP shortening in end-to-end latency [ms]')
xlabel('Percentile');
grid on
lh = legend('w/o Ack', 'w/ Ack');
set(lh,'Location','NorthWest')

percentile_delta_rel_val = [(percentile_val(1,:)-percentile_val(2,:))./percentile_val(2,:);(percentile_val(3,:)-percentile_val(4,:))./percentile_val(4,:)].*100;

figure(17)
bar(percentile_delta_rel_val.')
set(gca,'XTick',1:length(percentile));
set(gca,'XTickLabel',percentile*100);
ylabel('Gain of TXOP shortening in end-to-end latency [%]')
xlabel('Percentile');
grid on
lh = legend('w/o Ack', 'w/ Ack');
set(lh,'Location','NorthWest')
