clear all
close all
clc

load('BSS1_raw.mat');
dest_mac = '00:00:00_00:00:02 (00:00:00:00:00:02) (RA)';
dest_ip = '192.168.1.2';


data_BSS1 = data(strcmp(data(:,5), 'UDP') & strcmp(data(:,4), dest_ip) ,:);
BAR_BSS1 = data(strcmp(data(:,5),'802.11') & strcmp(data(:,4), dest_mac) & strcmp(data(:,7),'802.11 Block Ack Req, Flags=........C'),:);

dest_ip = '192.168.1.4';
data_BSS2 = data(strcmp(data(:,5), 'UDP') & strcmp(data(:,4), dest_ip) ,:);

retry_lat_BSS1_correction = [];
h = waitbar(0,'Please wait...');

for c = 1:length(BAR_BSS1)
    frame_no_BAR = BAR_BSS1{c,1};
    tmp = data_BSS1(cell2mat(data_BSS1(:,1)) < frame_no_BAR,1);
    
    % get reference number of failed AMPDU (=PPDU)
    ind_failedAMPDU = cell2mat(data_BSS1(cell2mat(data_BSS1(:,1))==tmp{end},8));
    
    % get frame number of last MPDU of failed AMPDU
    fn_startTXOPshort = cell2mat(data_BSS1(cell2mat(data_BSS1(:,1))==tmp{end},1));
    
    % get SNs being part of failed AMPDU
    sn_failedAMPDU = data_BSS1(cell2mat(data_BSS1(:,8))==ind_failedAMPDU,9);
    
    % get frame number after which last squence number has been successfully transmitted
    fn_lastSN_failedAMPDU = data_BSS1(cell2mat(data_BSS1(:,9))==sn_failedAMPDU{end} & cell2mat(data_BSS1(:,8))<ind_failedAMPDU+10 ,1);
    fn_stopTXOPshort = fn_lastSN_failedAMPDU{end};
    
    %%%% NOW: shorting space is determined to (fn_startTXOPshort fn_stopTXOPshort] interval
    %%%% [fn_startTXOPshort fn_stopTXOPshort]
    
    % get duration of content restriction by OBSS TXOP
    ind = cell2mat(data_BSS2(:,1))> fn_startTXOPshort & cell2mat(data_BSS2(:,1))<= fn_stopTXOPshort;
    OBSS_data = data_BSS2(ind,:);
    ind = cell2mat(data_BSS1(:,1))> fn_startTXOPshort & cell2mat(data_BSS1(:,1))<= fn_stopTXOPshort; 
    IBSS_data = data_BSS1(ind,:); 
    
    [OBSS_ampdu_no, ind_firstMPDUinOBSS_AMPDU ]= unique(cell2mat(OBSS_data(:,8)));
    
        
    reTxPending = true;
    for d = 1:length(OBSS_ampdu_no)
        if (~all(cell2mat(OBSS_data(cell2mat(OBSS_data(:,8))== OBSS_ampdu_no(d),11))==10) && reTxPending) % mean this A-MPDU has NOT only retries
           tmp2 = find(cell2mat(OBSS_data(cell2mat(OBSS_data(:,8))== OBSS_ampdu_no(d),11))==2);
           stop_time_all = OBSS_data(cell2mat(OBSS_data(:,8))== OBSS_ampdu_no(d),18);
           start_time_all = OBSS_data(cell2mat(OBSS_data(:,8))== OBSS_ampdu_no(d),20);
           start_time = start_time_all{tmp2(1)};
           stop_time = stop_time_all{tmp2(end)};
           reTxPending = false;
           % get duration of the interval [ind_first_new_MPDU .. ind_last_new_MPDU]
           shortend_dur = stop_time-start_time;
           fn_all = OBSS_data(cell2mat(OBSS_data(:,8))== OBSS_ampdu_no(d),1);
           fn_last_new_MPDU = fn_all{tmp2(end),1};
           % get all MPDUs with higher fn than last MPDU
           fns = cell2mat(IBSS_data(cell2mat(IBSS_data(:,1))>fn_last_new_MPDU,1));
           retry_lat_BSS1_correction = [retry_lat_BSS1_correction; fns shortend_dur.*ones(length(fns),1)];
        end        
    end
    waitbar(c./length(BAR_BSS1),h);    
end

close(h);
save BSS1_TXOPcontentrestriction.mat retry_lat_BSS1_correction

