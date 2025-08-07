clear all
close all
clc

load('BSS2_raw.mat');

dest_mac = '00:00:00_00:00:04 (00:00:00:00:00:04) (RA)';
dest_ip = '192.168.1.4';

data_BSS2 = data(strcmp(data(:,5), 'UDP') & strcmp(data(:,4), dest_ip) ,:);
BAR_BSS2 = data(strcmp(data(:,5),'802.11') & strcmp(data(:,4), dest_mac) & strcmp(data(:,7),'802.11 Block Ack Req, Flags=........C'),:);

dest_ip = '192.168.1.2';
data_BSS1 = data(strcmp(data(:,5), 'UDP') & strcmp(data(:,4), dest_ip) ,:);

retry_lat_BSS2_correction = [];
h = waitbar(0,'Please wait...');

for c = 1:length(BAR_BSS2)
    frame_no_BAR = BAR_BSS2{c,1};
    tmp = data_BSS2(cell2mat(data_BSS2(:,1)) < frame_no_BAR,1);
    
    % get reference number of failed AMPDU (=PPDU)
    ind_failedAMPDU = cell2mat(data_BSS2(cell2mat(data_BSS2(:,1))==tmp{end},8));
    
    % get frame number of last MPDU of last failed AMPDU
    fn_startTXOPshort = cell2mat(data_BSS2(cell2mat(data_BSS2(:,1))==tmp{end},1));
    
    % get SNs being part of failed AMPDU
    sn_failedAMPDU = data_BSS2(cell2mat(data_BSS2(:,8))==ind_failedAMPDU,9);
    
    % get frame number after which last squence number has been successfully transmitted
    fn_lastSN_failedAMPDU = data_BSS2(cell2mat(data_BSS2(:,9))==sn_failedAMPDU{end} & cell2mat(data_BSS2(:,8))<ind_failedAMPDU+10 ,1);
    fn_stopTXOPshort = fn_lastSN_failedAMPDU{end};
    
    %%%% NOW: shorting space is determined to (fn_startTXOPshort fn_stopTXOPshort] interval
    %[fn_startTXOPshort fn_stopTXOPshort]
    
    % get duration of shortening by OBSS TXOP
    ind = cell2mat(data_BSS1(:,1))> fn_startTXOPshort & cell2mat(data_BSS1(:,1))<= fn_stopTXOPshort;
    OBSS_data = data_BSS1(ind,:);
    ind = cell2mat(data_BSS2(:,1))> fn_startTXOPshort & cell2mat(data_BSS2(:,1))<= fn_stopTXOPshort;
    IBSS_data = data_BSS2(ind,:);
    
    [OBSS_ampdu_no, ind_firstMPDUinOBSS_AMPDU ]= unique(cell2mat(OBSS_data(:,8)));
    
    fn_firstMPDUinOBSS_AMPDU = cell2mat(OBSS_data(ind_firstMPDUinOBSS_AMPDU,1));
    
    shortend_dur = [];
    for d = 2:length(OBSS_ampdu_no)
        half_ind = floor((ind_firstMPDUinOBSS_AMPDU(d) - ind_firstMPDUinOBSS_AMPDU(d-1))./2);
        shortend_dur = [shortend_dur OBSS_data{ind_firstMPDUinOBSS_AMPDU(d-1)+half_ind-1,18} - OBSS_data{ind_firstMPDUinOBSS_AMPDU(d-1),20}];
    end
    if ~isempty(OBSS_ampdu_no)
        half_ind = floor((size(OBSS_data,1) - ind_firstMPDUinOBSS_AMPDU(end))./2);
        shortend_dur = [shortend_dur OBSS_data{ind_firstMPDUinOBSS_AMPDU(end)+half_ind-1,18} - OBSS_data{ind_firstMPDUinOBSS_AMPDU(end),20}];

        % compute latency advantage for all MPDUs in failed A-MPDU
        for d = 1:length(sn_failedAMPDU)
            ind = find(cell2mat(IBSS_data(:,9))==sn_failedAMPDU{d});
            if ~isempty(ind)
                ind = ind(end);
                cur_fn = IBSS_data{ind,1};
                lat_advantage = sum(shortend_dur(fn_firstMPDUinOBSS_AMPDU<cur_fn));
                retry_lat_BSS2_correction = [retry_lat_BSS2_correction; IBSS_data{ind,1} lat_advantage];
            end
        end
        
        % compute latency advantage for all MPDUs in A-MPDU used for
        % retransmission
        AMPDU_ref_no = IBSS_data{ind,8};
        
        fn_add = cell2mat(data_BSS2(cell2mat(data_BSS2(:,1))>cur_fn & cell2mat(data_BSS2(:,8))==AMPDU_ref_no, 1));
        
        retry_lat_BSS2_correction = [retry_lat_BSS2_correction; fn_add lat_advantage.*ones(length(fn_add),1)];
    end
    
    waitbar(c./length(BAR_BSS2),h);    
    
end

close(h);
save BSS2_TXOPshortening.mat retry_lat_BSS2_correction
