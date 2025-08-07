clear all
close all
clc


%% EVAL
filen = 'test_new_all_results.mat';
load(filen)

%% PLOT
%%
figure(1)
yyaxis left
plot(results.MCS.time,results.MCS.data,'Marker','o','LineStyle','none')
ylabel('MCS')
set(gca,'YTick',0:7)
yyaxis right
plot(results.AMPDU_size.time,results.AMPDU_size.data,'Marker','x','LineStyle','none')
ylabel('A-MPDU size')
grid on
xlabel('relative time (s)')


figure(2)
yyaxis left
plot(results.MCS.time,results.MCS.data,'Marker','x','LineStyle','none')
ylabel('MCS')
set(gca,'YTick',0:7)
yyaxis right
plot(results.retry.perAMPDU.time,results.retry.perAMPDU.data./results.AMPDU_size.data.','Marker','o','LineStyle','none')
grid on
xlabel('relative time (s)');
ylabel('avg. num. of retries per A-MPDU');


figure(3)
yyaxis left
plot(results.MCS.time,results.MCS.data,'Marker','x','LineStyle','none')
ylabel('MCS')
set(gca,'YTick',0:7)
yyaxis right
plot(results.retry.perMPDU.time,results.retry.perMPDU.data,'Marker','o','LineStyle','none')
ylabel('Retries of each transmitted MPDU')
grid on
xlabel('relative time (s)');

figure(4)
plot(results.retry.perSeqNum.xaxis, results.retry.perSeqNum.data)
xlabel('sequence number')
ylabel('retries per sequence number')
grid on

fig=figure; set(fig,'visible','off');
h = histogram(results.retry.perSeqNum.data,[(0:10)-0.1 inf]);
hist_num_retries_per_seq_num = h.Values;
close(fig);

figure(5)
semilogy(0:10,hist_num_retries_per_seq_num./sum(hist_num_retries_per_seq_num))
grid on
xlabel('Num. of retries')
ylabel('Probability')

labelStr = get(gca,'XTickLabel');
labelStr{end} = '\geq10';
set(gca,'XTickLabel',labelStr);

figure(6)
yyaxis left
plot(results.MCS.time,results.MCS.data,'Marker','o','LineStyle','none')
ylabel('MCS')
set(gca,'YTick',0:7)

yyaxis right
plot(results.PER.time,results.PER.data)
ylabel('PER [0.5s average]')

grid on
xlabel('relative time (s)')


figure(7)
yyaxis left
plot(results.MCS.time,results.MCS.data,'Marker','o','LineStyle','none')
ylabel('MCS')
set(gca,'YTick',0:7)

yyaxis right
plot(results.tput.time,results.tput.data./1e6)
ylabel('Throughput [Mbps] [0.5s average]')

grid on
xlabel('relative time (s)')
%%

figure(8)
yyaxis left
plot(results.MCS.xaxis,results.MCS.data,'Marker','o','LineStyle','none')
ylabel('MCS')
set(gca,'YTick',0:7)
yyaxis right
plot(results.latency.xaxis,results.latency.retry.data./1e-6,'Marker','o','LineStyle','none') % +1 because it starts at zero
% hold on
% plot(results.latency.xaxis,results.latency.firstTX.data./1e-6,'Marker','^','LineStyle','none')
% plot(results.latency.xaxis,results.latency.aggregation.data./1e-6,'Marker','d','LineStyle','none')
% plot(results.latency.xaxis,results.latency.congestion.data./1e-6,'Marker','x','LineStyle','none')
% plot(results.latency.xaxis,results.latency.ack.data./1e-6,'Marker','s','LineStyle','none')
% hold off
grid on
xlabel('Sequence number')
%%
figure(9)
yyaxis left
plot(results.retry.perSeqNum.xaxis, results.retry.perSeqNum.data,'Marker','o','LineStyle','none')
ylabel('retries')
% set(gca,'YTick',0:7)

yyaxis right
plot(results.latency.xaxis,results.latency.retry.data./1e-6,'Marker','o','LineStyle','none')
% hold on
% plot(results.latency.xaxis,results.latency.firstTX.data./1e-6,'Marker','^','LineStyle','none')
% plot(results.latency.xaxis,results.latency.aggregation.data./1e-6,'Marker','d','LineStyle','none')
% plot(results.latency.xaxis,results.latency.congestion.data./1e-6,'Marker','x','LineStyle','none')
% plot(results.latency.xaxis,results.latency.ack.data./1e-6,'Marker','s','LineStyle','none')
ylabel('Latency [µs]')
grid on
xlabel('Sequence number')