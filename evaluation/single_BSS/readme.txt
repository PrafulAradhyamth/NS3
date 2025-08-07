Steps to obtain graphics:

1. use the PCAP in this folder
2. open PCAP in wireshark and export it a csv file (NOTE: scripts are made for AP PCAPs)
3. use "pcap2mat.m" (uses "importfile.m") to import csv to ..._raw.mat matlab data
4. use "compileResults.m" to compile various key performance indicators (e.g. throughput, latency, etc.) from ..._raw.mat. The output data is store in ..._results.mat
5. draw graphics with "eval4presentation.m" or "evalResults.m"
