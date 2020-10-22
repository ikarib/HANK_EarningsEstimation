## Usage

This repository contains a submodule [`DFLS`](../../../DFLS). To build, do:
```
git clone --recursive https://github.com/ikarib/HANK_EarningsEstimation.git
cd HANK_EarningsEstimation/DFLS
make
cd ..
make
```
To run on Slurm cluster manager, edit [`submit.sh`](./submit.sh) and run:
```
sbatch submit.sh
```
Otherwise, just run:
```
./estimate N
```
where N is the exponent in the 2<sup>N</sup> Monte Carlo simulations to run on GPUs.
