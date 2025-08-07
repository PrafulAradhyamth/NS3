clear all
close all
clc

filen = 'BSS2_TXOPshortening_results.mat'; % filen = 'BSS1_TXOPcontentRestriction_results.mat';
a = load(filen);

filen = 'BSS2_TXOPcontentRestriction_results.mat'; % filen = 'BSS1_TXOPcontentRestriction_results.mat';
b = load(filen);

min_lim = 1;
max_lim = 67000;

lat_noAck = a.results.latency.congestion.data./1e-6 + a.results.latency.aggregation.data./1e-6 + a.results.latency.retry.data./1e-6;
lat_ack = a.results.latency.congestion.data./1e-6 + a.results.latency.aggregation.data./1e-6 + a.results.latency.retry.data./1e-6 + a.results.latency.ack.data./1e-6;

lat_noAck_wShort = a.results.latency.congestion.data./1e-6 + a.results.latency.aggregation.data./1e-6 + a.results.latency.retry.data./1e-6 - a.results.latency.retry.TXOPshortening_data./1e-6;
lat_ack_wShort = a.results.latency.congestion.data./1e-6 + a.results.latency.aggregation.data./1e-6 + a.results.latency.retry.data./1e-6 + a.results.latency.ack.data./1e-6 - a.results.latency.retry.TXOPshortening_data./1e-6;


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


lat_noAck_wShort = b.results.latency.congestion.data./1e-6 + b.results.latency.aggregation.data./1e-6 + b.results.latency.retry.data./1e-6 - b.results.latency.retry.TXOPcontentRestriction_data./1e-6;
lat_ack_wShort = b.results.latency.congestion.data./1e-6 + b.results.latency.aggregation.data./1e-6 + b.results.latency.retry.data./1e-6 + b.results.latency.ack.data./1e-6 - b.results.latency.retry.TXOPcontentRestriction_data./1e-6;

fig=figure; set(fig,'visible','off');
hist_lat_noAck_wContRes_x = [0:50e3 inf];
hist_h = histogram(lat_noAck_wShort(min_lim:max_lim),hist_lat_noAck_wContRes_x,'Normalization','cdf');
hist_lat_noAck_wContRes_x = hist_lat_noAck_wContRes_x(1:end-1);
hist_lat_noAck_wContRes = hist_h.Values;
close(fig);

fig=figure; set(fig,'visible','off');
hist_lat_ack_wContRes_x = [0:50e3 inf];
hist_h = histogram(lat_ack_wShort(min_lim:max_lim),hist_lat_ack_wContRes_x,'Normalization','cdf');
hist_lat_ack_wContRes_x = hist_lat_ack_wContRes_x(1:end-1);
hist_lat_ack_wContRes = hist_h.Values;
close(fig);

hist_lat_ack_wShort = movmean(hist_lat_ack_wShort,3);
hist_lat_ack = movmean(hist_lat_ack,3);
hist_lat_ack_wContRes = movmean(hist_lat_ack_wContRes,3);

figure(1)
plot(hist_lat_noAck_x./1e3,hist_lat_noAck)
hold on
plot(hist_lat_noAck_wShort_x./1e3,hist_lat_noAck_wShort)
% plot(hist_lat_noAck_wContRes_x./1e3,hist_lat_noAck_wContRes)
plot(hist_lat_ack_x./1e3,hist_lat_ack)
plot(hist_lat_ack_wShort_x./1e3,hist_lat_ack_wShort)
% plot(hist_lat_ack_wContRes_x./1e3,hist_lat_ack_wContRes)
hold off
grid on
xlabel('End-to-end latency [ms]')
ylabel('CDF')
lh = legend('w/o Ack','w/o Ack w/ TXOP limit shortening','w/ Ack','w/ Ack w/ TXOP limit shortening');
% lh = legend('w/o Ack','w/o Ack w/ TXOP shortening','w/ Ack','w/ Ack w/ TXOP shortening');
set(lh,'Location','SouthEast');
ylim([0 1])
% set(get(gca,'XAxis'),'Exponent',3)

figure(2)
plot(hist_lat_noAck_x./1e3,hist_lat_noAck)
hold on
plot(hist_lat_noAck_wShort_x./1e3,hist_lat_noAck_wShort)
% plot(hist_lat_noAck_wContRes_x./1e3,hist_lat_noAck_wContRes)
plot(hist_lat_ack_x./1e3,hist_lat_ack)
plot(hist_lat_ack_wShort_x./1e3,hist_lat_ack_wShort)
% plot(hist_lat_ack_wContRes_x./1e3,hist_lat_ack_wContRes)
hold off
grid on
xlabel('End-to-end latency [ms]')
ylabel('CDF')
lh = legend('w/o Ack','w/o Ack w/ TXOP limit shortening','w/ Ack','w/ Ack w/ TXOP limit shortening');
% lh = legend('w/o Ack','w/o Ack w/ TXOP shortening','w/ Ack','w/ Ack w/ TXOP shortening');
set(lh,'Location','SouthEast');
ylim([0.9 1])


percentile = [0.9 0.95 0.99];

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

% for c = 1:size(percentile_val,2)
%     ind = find(hist_lat_noAck_wContRes>percentile(c));
%     if ~isempty(ind)
%         percentile_val(3,c) = hist_lat_noAck_wContRes_x(ind(1));
%     end
% end

% for c = 1:size(percentile_val,2)
%     ind = find(hist_lat_ack_wContRes>percentile(c));
%     if ~isempty(ind)
%         percentile_val(6,c) = hist_lat_ack_wContRes_x(ind(1));
%     end
% end

figure(3)
bar(percentile_val.'./1e3)
set(gca,'XTick',1:length(percentile));
set(gca,'XTickLabel',percentile*100);
ylabel('end-to-end latency [ms]')
xlabel('Percentile');
lh = legend('w/o Ack', 'w/o Ack w/ TXOP limit shortening', 'w/ Ack', 'w/ Ack w/ TXOP limit shortening');
set(lh,'Location','NorthWest')
grid on
ylim([10 40])

% percentile_delta_val = [percentile_val(1,:)-percentile_val(2,:);percentile_val(1,:)-percentile_val(3,:);percentile_val(4,:)-percentile_val(5,:);percentile_val(4,:)-percentile_val(6,:)];
% 
% figure(4)
% bar(percentile_delta_val.'./1e3)
% set(gca,'XTick',1:length(percentile));
% set(gca,'XTickLabel',percentile*100);
% ylabel('Gain in end-to-end latency [ms]')
% xlabel('Percentile');
% grid on
% lh = legend('w/o Ack (shortening)', 'w/o Ack (content restriction)', 'w/ Ack (shortening)', 'w/ Ack (content restriction)');
% set(lh,'Location','NorthWest')
% 
% percentile_delta_val_rel = [(percentile_val(1,:)-percentile_val(2,:))./percentile_val(1,:);(percentile_val(1,:)-percentile_val(3,:))./percentile_val(1,:);(percentile_val(4,:)-percentile_val(5,:))./percentile_val(4,:);(percentile_val(4,:)-percentile_val(6,:))./percentile_val(4,:)];
% 
% figure(5)
% bar(percentile_delta_val_rel.'.*100)
% set(gca,'XTick',1:length(percentile));
% set(gca,'XTickLabel',percentile*100);
% ylabel('Gain in end-to-end latency [%]')
% xlabel('Percentile');
% grid on
% lh = legend('w/o Ack (shortening)', 'w/o Ack (content restriction)', 'w/ Ack (shortening)', 'w/ Ack (content restriction)');
% set(lh,'Location','NorthWest')
% 
