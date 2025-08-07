# NS3 Quick Installation and Simulation README

This guide provides a **succinct reference** to install, build, and use ns-3 (Network Simulator 3) on a Linux system. For troubleshooting and extended details, refer to the official documentation and wiki.[1][2]

## Installation Steps

1. **Download ns-3**
   - Get the latest source tarball from: https://www.nsnam.org/releases

2. **Extract the Tarball**
   - Unzip the downloaded file. Example:
     ```sh
     tar xjf ns-allinone-3.30.tar.bz2
     ```

3. **Install Dependencies**
   - Ensure the following packages are installed (for Ubuntu/Debian/Mint):
     ```sh
     sudo apt update
     sudo apt install gcc g++ python python3
     ```
   - For more advanced options or other distributions, see the wiki’s platform-specific package lists.[2]

4. **Navigate to Source Directory**
   - Change to the directory containing the waf utility:
     ```sh
     cd ns-allinone-3.30/ns-3.30
     ```

5. **Build ns-3**
   - Configure the build (only needed once):
     ```sh
     ./waf configure --build-profile=debug --enable-tests --enable-examples
     ```
   - Compile source:
     ```sh
     ./waf
     ```
   - Run the above command every time you change code for recompilation.

## Running Simulations

- Simulation scripts are placed in the `scratch/` directory.
- To run a script:
  ```sh
  ./waf --run scratch/your-file-name.cc
  ```
- Output PCAP traces are saved in the project root (same level as waf).

## Handling PCAP Files

- Generated PCAP files can be analyzed using Wireshark, Matlab, Python, or your tool of choice.

## NS3 Scenario Summary

- Find scenario scripts in `scratch/`:
  - `fixed-downlink.cc`: **No interference**, fixed AP/STA positions.
  - `fixed-downlink-plus.cc`: **With interference** (two BSS on one channel), fixed AP/STA.
  - `moving-downlink.cc`: **No interference**, STA moves away from AP.
  - `moving-downlink-plus.cc`: **With interference**, STA moves away from AP.

## Replicating and Verifying Work

1. Download and freshly install ns-3 from official sources (do **not** reuse existing folders without following install steps).
2. For ns-3.30, apply the patch as instructed in PATCH-README (fixes a known bug in Minstrel-HT).
3. For testing custom Minstrel-HT variants, copy chosen Minstrel-HT-Plus sources into `src/wifi/model/` before building.

## Python Analysis Scripts

1. Ensure Python is installed.
2. Install necessary modules:
   ```sh
   pip install jupyter pandas numpy matplotlib
   ```
3. Copy and paste the code cells (not the whole notebook file) into your local Jupyter instance for best compatibility.

## Reference

- **Official ns-3 Documentation and Installation Wiki:**  
  - https://www.nsnam.org/docs/release/3.30/tutorial/singlehtml/index.html
  - https://www.nsnam.org/wiki/Installation
