clear all
close all
clc


%% EVAL
dest_ip = '192.168.1.2';
dest_mac = '00:00:00_00:00:02 (00:00:00:00:00:02) (TA)';
% dest_ip = '192.168.1.4';
% dest_mac = '00:00:00_00:00:04 (00:00:00:00:00:04) (TA)';

filen = 'BSS1_results.mat'; % BSS2_results.mat
load('BSS1_raw.mat'); % BSS2_raw.mat
load('BSS1_TXOPshortening.mat')

% restrict to data transmission only
data_only_data_BSS1 = data(strcmp(data(:,5), 'UDP') & strcmp(data(:,4), dest_ip) ,:);

% restrict to data transmission only
control_only_data_BSS1 = data(strcmp(data(:,5),'802.11') & strcmp(data(:,3), dest_mac) & strcmp(data(:,7),'802.11 Block Ack, Flags=........C') | strcmp(data(:,7),'Acknowledgement, Flags=........C'),:);

clear data

% extract starting time of a_mpdu, mcs, a_mpdu size
[rows,~] = size(data_only_data_BSS1);

a_mpdu_ref_number = zeros(rows,1);
offset = 0;
old_tmp = -1;
%%
for r = 1:rows % bug fix in pcap
    % this is to have an A-MPDU sequence number for non A-MPDU
    % transmissions
    tmp = cell2mat(data_only_data_BSS1(r,8));
    if isempty(tmp) 
        offset = offset + 1;
        a_mpdu_ref_number(r) = a_mpdu_ref_number(r-1) + 1;
    else
        a_mpdu_ref_number(r) = tmp + offset;
    end
    
    % this is to fix timings
%     prea = cell2mat(data_only_data_BSS1(r,16));
%     dura = cell2mat(data_only_data_BSS1(r,15));
    if ~isempty(tmp)        
        if old_tmp==tmp % copy
            data_only_data_BSS1(r,15) = data_only_data_BSS1(r-1,15);
            data_only_data_BSS1(r,16) = data_only_data_BSS1(r-1,16);
        else % don't copy
            old_tmp=tmp;
            data_only_data_BSS1{r,15} = data_only_data_BSS1{r,15}+4e-6;
        end        
    end
    
        
end
% a_mpdu_ref_number_old = cell2mat(data_only_data(:,8));
% if strcmp(dest_ip,'192.168.1.4')
%     a_mpdu_ref_number = a_mpdu_ref_number./2.^16; % this is to remove offset in a_mpdu_ref_number (which is present in 2nd BSS)
% end

[a_mpdu_ref_number_unique,a_mpdu_ref_number_unique_ind,a_mpdu_ref_number_same_ind] = unique(a_mpdu_ref_number);

time_ampdu = cell2mat(data_only_data_BSS1(a_mpdu_ref_number_unique_ind,2));
mcs = cell2mat(data_only_data_BSS1(a_mpdu_ref_number_unique_ind,14));

ampdu_size = sum(a_mpdu_ref_number_unique(a_mpdu_ref_number_same_ind) == a_mpdu_ref_number_unique.');

% ampdu_size_bytes = zeros(length(a_mpdu_ref_number_unique),1);
% mpdu_bytes = cell2mat(data_only_data(:,10)); 
% 
% for cnt = 1:length(a_mpdu_ref_number_unique)
%     ampdu_size_bytes(cnt) = sum(mpdu_bytes(a_mpdu_ref_number_same_ind==a_mpdu_ref_number_unique(cnt)));
% end

% extract sequence number
seq_number = cell2mat(data_only_data_BSS1(:,9));

% unwrap sequence number parameters
transition_region = 1023;
transition_threshold = 2047;
max_seq_number = 4095;

seq_number_unwrap = seq_number;

%%
oflw = 0;
oflw_hyst = 0;

for c = 1:length(seq_number)
    if ((0<=seq_number(c)) && (seq_number(c)<=transition_threshold) && (oflw_hyst~=0))
        seq_number_unwrap(c) = seq_number(c)+oflw*(max_seq_number+1);
    elseif (seq_number(c)>transition_threshold) && (oflw_hyst~=0)
        seq_number_unwrap(c) = seq_number(c)+(oflw-1)*(max_seq_number+1);
    else
        seq_number_unwrap(c) = seq_number(c)+oflw*(max_seq_number+1);
    end
    
        
    if seq_number(c)==max_seq_number && oflw_hyst==0
        oflw = oflw+1;
        oflw_hyst = 1;
    elseif oflw_hyst>0
        oflw_hyst = oflw_hyst + 1;
    end
    
    if oflw_hyst>=transition_region
        oflw_hyst = 0;
    end
    
end
      

%%
% extract retries per unwrapped sequence number
num_retries_per_seq_num = zeros(length(unique(seq_number_unwrap)),1);
retry_lat_reduction = zeros(length(num_retries_per_seq_num),1); % <== new
num_retries_per_ampdu = zeros(length(a_mpdu_ref_number_unique),1);
num_retries_per_mpdu = zeros(length(seq_number_unwrap),1);

% get retry information
mpdu_flags = cell2mat(data_only_data_BSS1(:,11));
retry = logical(mod(floor(mpdu_flags./8),2));
frame_number = cell2mat(data_only_data_BSS1(:,1));

notsame = 0;
empty = 0;

for c = 1:length(seq_number_unwrap)
    if retry(c)==1
        num_retries_per_ampdu(a_mpdu_ref_number(c)+1) = num_retries_per_ampdu(a_mpdu_ref_number(c)+1) + 1;
        num_retries_per_seq_num(seq_number_unwrap(c)+1) = num_retries_per_seq_num(seq_number_unwrap(c)+1) + 1;
        num_retries_per_mpdu(c) = num_retries_per_seq_num(seq_number_unwrap(c)+1);
        
        fn = frame_number(c);
        cand_corr_terms = retry_lat_BSS1_correction(retry_lat_BSS1_correction(:,1)==fn,2);
        
        if ~isempty(cand_corr_terms)
            if all(cand_corr_terms == cand_corr_terms(1)) % check if all elements are same
                retry_lat_reduction(seq_number_unwrap(c)+1) = cand_corr_terms(1);
            else
                notsame = notsame+1
            end
        else
            empty = empty+1
        end 
    end    
end
 
time_ampdu_rel = time_ampdu-time_ampdu(1);
%%
% compute PER and throughput over window of certain length
l_win = 0.5; % in seconds
per = zeros(ceil(max(time_ampdu_rel)./l_win),1);
per_time = zeros(length(per),1);
tput = zeros(ceil(max(time_ampdu_rel)./l_win),1);
tput_time = zeros(length(per),1);

mpdu_bytes = unique(cell2mat(data_only_data_BSS1(:,10))); 
if ~isscalar(mpdu_bytes)
   error('throughput computation assumes constant size of mpdu');
end

for cnt = 1:length(per)
    time_ind = (time_ampdu_rel<=l_win.*cnt)&(l_win.*(cnt-1)<time_ampdu_rel);
      
    per(cnt) = sum(num_retries_per_ampdu(time_ind))./sum(ampdu_size(time_ind));
    per_time(cnt) = l_win./2 + l_win*(cnt-1);    
    
%     tput(cnt) = (sum(ampdu_size(time_ind))-sum(num_retries_per_ampdu(time_ind))).*mean(ampdu_size_bytes(time_ind))*.8./l_win;
    tput(cnt) = (sum(ampdu_size(time_ind))-sum(num_retries_per_ampdu(time_ind))).*mpdu_bytes.*8./l_win;
    tput_time(cnt) = per_time(cnt);
end

%% compute timing information
tsf_start = cell2mat(data_only_data_BSS1(:,20)); % start time of a MPDU in s
tsf_end = cell2mat(data_only_data_BSS1(:,18)); % end time of a MPDU in s
duration = cell2mat(data_only_data_BSS1(:,15)); % length of PPDU in s
preamble = cell2mat(data_only_data_BSS1(:,16)); % preamble length of PPDU in s
number_data = cell2mat(data_only_data_BSS1(:,1)); % number of recorded transmission (in data)
number_ctrl = cell2mat(control_only_data_BSS1(:,1)); % number of recorded transmission (in ctrl)
tsf_ctrl = cell2mat(control_only_data_BSS1(:,20)); % start time of a MPDU in s (this actually equals end time)
dur_ctrl = cell2mat(control_only_data_BSS1(:,15)); % length of PPDU in s

seq_number_unwrap_unique = unique(seq_number_unwrap);
tot_lat = zeros(length(seq_number_unwrap_unique),1); % latency including retry but not 1st congestion delay
tot_lat_time = zeros(length(seq_number_unwrap_unique),1);
firstTx_lat = zeros(length(seq_number_unwrap_unique),1); % latency of first transmission without congestion delay
agg_lat = zeros(length(seq_number_unwrap_unique),1); % AMPDU aggregation delay
cong_lat = zeros(length(seq_number_unwrap_unique),1); % congestion latency
ack_lat = zeros(length(seq_number_unwrap_unique),1); % Ack latency

previousMPDUatBeginningOfPPDUind = -1;


for c = 1:length(seq_number_unwrap_unique)
    cur_seq_num = seq_number_unwrap_unique(c);
    log_ind = find(seq_number_unwrap==cur_seq_num);
    tot_lat(c) = tsf_start(log_ind(end))-tsf_start(log_ind(1)) + duration(log_ind(end)); % OK
    tot_lat_time(c) = tsf_start(log_ind(1));
    firstTx_lat(c) = duration(log_ind(1)); % OK
    
    
    % check if MPDU is NOT at beginning of PPDU, in this case:
    % + substract preamble length, because it is part of an A-MPDU
    % + add aggregation latency, because A-MPDU was complete at beginning of transmission
    % + add preamble length to ACK latency
   
    if ~any(a_mpdu_ref_number_unique_ind==log_ind(end)) % NOT AT BEGINNING OF PPDU
        tot_lat(c) = tot_lat(c) - preamble(log_ind(end)); % OK
        firstTx_lat(c) = firstTx_lat(c) - preamble(log_ind(1)); % OK
        ack_lat(c) = ack_lat(c) + preamble(log_ind(end));
    end
    
    % compute aggregation latency
    first_mpdu_in_ppdu_ind = a_mpdu_ref_number_unique_ind(a_mpdu_ref_number_same_ind(log_ind(1)));
    init_first_mpdu_in_ppdu_ind = first_mpdu_in_ppdu_ind;
    while retry(first_mpdu_in_ppdu_ind)==1 % need different reference
        first_mpdu_in_ppdu_ind = first_mpdu_in_ppdu_ind+1;
        if init_first_mpdu_in_ppdu_ind+100<first_mpdu_in_ppdu_ind
            break;
        end
    end
    agg_lat(c) = tsf_start(log_ind(1))-tsf_start(first_mpdu_in_ppdu_ind);
    
    
    % check if MPDU is at the beginning of a PPDU, in this case:
    % + compute the congestion delay
    % if not, carry congestion delay forward, unless the MPDU is
    % transmitted first in a PPDU
    if any(a_mpdu_ref_number_unique_ind==log_ind(1))
        cur_num_data = number_data(log_ind(1)); % packet number of 1st transmission
        
        delta = number_ctrl-cur_num_data;
        delta_ind = find(delta<0); 
        cur_ctrl_ind = delta_ind(end); % BAck just before transmission
        
        if log_ind(1)~=1
            cong_lat(c) = tsf_start(log_ind(1))-tsf_end(log_ind(1)-1)- 16e-6 - dur_ctrl(cur_ctrl_ind);
        else
            cong_lat(c) = tsf_start(log_ind(1))-tsf_ctrl(cur_ctrl_ind)-dur_ctrl(cur_ctrl_ind);
        end
        
        if (previousMPDUatBeginningOfPPDUind~=-1) && (isscalar(log_ind)==1)
            previousMPDUatBeginningOfPPDUind = -1; 
        end
    else
        if all(previousMPDUatBeginningOfPPDUind>0) && any(retry(previousMPDUatBeginningOfPPDUind)) && (isscalar(log_ind)==1) % if there was a previous MPDU at the beginning which was retransmitted later and if the current MPDU is transmitted only once (THIS means that a MPDU is first MPDU in an PPDU that is transmitted only once)
            % compute
            [~,delta_ind] = min(log_ind-previousMPDUatBeginningOfPPDUind);
            cur_num_data = number_data(previousMPDUatBeginningOfPPDUind(delta_ind)); % packet number of 1st transmission
            
            delta = number_ctrl-cur_num_data;
            delta_ind = find(delta<0);
            cur_ctrl_ind = delta_ind(end); % BAck just before transmission
            
            if previousMPDUatBeginningOfPPDUind(1)~=1
                cong_lat(c) = tsf_start(previousMPDUatBeginningOfPPDUind(1))-tsf_end(previousMPDUatBeginningOfPPDUind(1)-1)- 16e-6 - dur_ctrl(cur_ctrl_ind);
            else
                cong_lat(c) = tsf_start(previousMPDUatBeginningOfPPDUind(1))-tsf_ctrl(cur_ctrl_ind)-dur_ctrl(cur_ctrl_ind);
            end
            
            previousMPDUatBeginningOfPPDUind = -1;            
        else % carry forward
            cong_lat(c) = cong_lat(c-1);
        end
    end
    
    % check in case of retransmission, if a PPDU starts with a
    % retransmitted MPDU
    cnt = 2;
    while cnt<=length(log_ind)
        if any(a_mpdu_ref_number_unique_ind==log_ind(cnt))
            previousMPDUatBeginningOfPPDUind = log_ind(cnt);
        end
        cnt = cnt+1;
    end
    
    
    delta_ind = number_ctrl-number_data(log_ind(end)); % consider last MPDU transmitted (this includes retransmisson)
    min_delta_ind = min(delta_ind(delta_ind>=0)); % BACk just after the last MPDU transmission
    if ~isempty(min_delta_ind)
       back_ind = find(delta_ind==min_delta_ind);
       ack_lat(c) = ack_lat(c) + tsf_ctrl(back_ind) - tsf_start(log_ind(end))-duration(log_ind(end));
    else
       ack_lat(c) = 0;
    end   
    
end

%% save results
% get mpdu time
time_mpdu = cell2mat(data_only_data_BSS1(:,2));
time_mpdu_rel = time_mpdu-time_mpdu(1);


results.MCS.data = mcs;
results.MCS.time = time_ampdu_rel;
results.MCS.xaxis = a_mpdu_ref_number_unique_ind;
results.AMPDU_size.data = ampdu_size;
results.AMPDU_size.time = time_ampdu_rel;
results.retry.perAMPDU.data = num_retries_per_ampdu;
results.retry.perAMPDU.time = time_ampdu_rel;
results.retry.perMPDU.data = num_retries_per_mpdu;
results.retry.perMPDU.time = time_mpdu_rel;
results.retry.perSeqNum.data = num_retries_per_seq_num;
results.retry.perSeqNum.xaxis = unique(seq_number_unwrap);
results.PER.data = per;
results.PER.time = per_time;
results.tput.data = tput;
results.tput.time = tput_time;
results.latency.retry.data = tot_lat;
results.latency.firstTX.data = firstTx_lat;
results.latency.aggregation.data = agg_lat;
results.latency.congestion.data = cong_lat;
results.latency.ack.data = ack_lat;
results.latency.xaxis = seq_number_unwrap_unique;
results.latency.time= tot_lat_time;
results.latency.retry.TXOPshortening_data = retry_lat_reduction;

save([filen(1:end-4) '_TXOPshortening.mat'], 'results');
%%
figure(1)
yyaxis left
plot(time_ampdu_rel,mcs,'Marker','o','LineStyle','none')
ylabel('MCS')
set(gca,'YTick',0:7)

yyaxis right
plot(time_ampdu_rel,ampdu_size,'Marker','x','LineStyle','none')
ylabel('A-MPDU size')

grid on
xlabel('relative time (s)')

% figure(2)
% plot(time_mpdu_rel,seq_number)
% hold on
% plot(time_mpdu_rel,seq_number_unwrap)
% hold off
% grid on
% xlabel('relative time (s)')
% ylabel('sequence number')
% legend('wrapped','unwrapped');

figure(2)
yyaxis left
plot(time_ampdu_rel,mcs,'Marker','x','LineStyle','none')
ylabel('MCS')
set(gca,'YTick',0:7)
yyaxis right
plot(time_ampdu_rel,num_retries_per_ampdu./ampdu_size.','Marker','o','LineStyle','none')
% plot(time_mpdu_rel,num_retries_over_time,'Marker','o','LineStyle','none')
grid on
xlabel('relative time (s)');
ylabel('avg. num. of retries per A-MPDU');

figure(3)
yyaxis left
plot(time_ampdu_rel,mcs,'Marker','x','LineStyle','none')
ylabel('MCS')
set(gca,'YTick',0:7)
yyaxis right
plot(time_mpdu_rel,num_retries_per_mpdu,'Marker','o','LineStyle','none')
ylabel('Retries of each transmitted MPDU')
grid on
xlabel('relative time (s)');

figure(4)
plot(unique(seq_number_unwrap), num_retries_per_seq_num)
xlabel('sequence number')
ylabel('retries per sequence number')
grid on

fig=figure; set(fig,'visible','off');
h = histogram(num_retries_per_seq_num,[(0:10)-0.1 inf]);
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
plot(time_ampdu_rel,mcs,'Marker','o','LineStyle','none')
ylabel('MCS')
set(gca,'YTick',0:7)

yyaxis right
plot(per_time,per)
ylabel('PER [0.5s average]')

grid on
xlabel('relative time (s)')


figure(7)
yyaxis left
plot(time_ampdu_rel,mcs,'Marker','o','LineStyle','none')
ylabel('MCS')
set(gca,'YTick',0:7)

yyaxis right
plot(tput_time,tput./1e6)
ylabel('Throughput [Mbps] [0.5s average]')

grid on
xlabel('relative time (s)')
%%

figure(8)
yyaxis left
plot(a_mpdu_ref_number_unique_ind,mcs,'Marker','o','LineStyle','none')
ylabel('MCS')
set(gca,'YTick',0:7)
yyaxis right
plot(seq_number_unwrap_unique+1,tot_lat./1e-6,'Marker','o','LineStyle','none') % +1 because it starts at zero
% hold on
% % plot(seq_number_unwrap_unique+1,firstTx_lat./1e-6,'Marker','^','LineStyle','none') % +1 because it starts at zero
% plot(seq_number_unwrap_unique+1,agg_lat./1e-6,'Marker','d','LineStyle','none') % +1 because it starts at zero
% plot(seq_number_unwrap_unique+1,cong_lat./1e-6,'Marker','x','LineStyle','none') % +1 because it starts at zero
% plot(seq_number_unwrap_unique+1,ack_lat./1e-6,'Marker','s','LineStyle','none') % +1 because it starts at zero
% hold off
grid on
xlabel('Sequence number')
%%
figure(9)
yyaxis left
plot(seq_number_unwrap_unique+1,num_retries_per_seq_num,'Marker','o','LineStyle','none')
ylabel('retries')
set(gca,'YTick',0:7)
yyaxis right
plot(seq_number_unwrap_unique+1,ack_lat./1e-6,'Marker','o','LineStyle','none') % +1 because it starts at zero
% hold on
% % plot(seq_number_unwrap_unique+1,firstTx_lat./1e-6,'Marker','^','LineStyle','none') % +1 because it starts at zero
% plot(seq_number_unwrap_unique+1,agg_lat./1e-6,'Marker','d','LineStyle','none') % +1 because it starts at zero
% plot(seq_number_unwrap_unique+1,cong_lat./1e-6,'Marker','x','LineStyle','none') % +1 because it starts at zero
% plot(seq_number_unwrap_unique+1,ack_lat./1e-6,'Marker','s','LineStyle','none') % +1 because it starts at zero
% hold off
ylabel('Latency [µs]')
grid on
xlabel('Sequence number')