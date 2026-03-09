# GPU-Accelerated Stochastic Simulation for Large-Scale Economic Modeling

## Overview

This project involved building a **GPU-accelerated stochastic simulation system** to estimate a structural income process used in heterogeneous-agent macroeconomic models.

The core challenge was that the estimation procedure required **millions of Monte Carlo simulations**, making traditional CPU-based implementations prohibitively slow.

The solution was to redesign the system using **CUDA-based parallel computing on GPUs**, enabling extremely large simulation workloads to run efficiently.

The research is described in the Bank of Canada discussion [paper](https://www.bankofcanada.ca/wp-content/uploads/2020/12/sdp2020-13.pdf):

**Toward a HANK Model for Canada: Estimating a Canadian Income Process**.  

---

# Problem

The project estimated a **stochastic earnings process** for households using a **simulated method of moments**.

The model represents individual income dynamics using a **continuous-time stochastic process with Poisson-arriving jumps** and mean-reverting components.

Key features of the model:

- Separate **transitory and persistent income shocks**
- **Jump-diffusion style process** capturing rare but large shocks
- Calibration using **empirical income distribution moments**

Parameter estimation required repeatedly:

1. Simulating large numbers of income trajectories
2. Computing distribution moments (variance, kurtosis, etc.)
3. Comparing simulated moments with empirical data

Because the objective function evaluation required **millions of simulations**, estimation became computationally expensive.

---

# Approach

The main solution was to **parallelize the simulation system using CUDA on GPUs**.

## 1. Parallel Monte Carlo Simulation

Each simulated household trajectory is independent, making the model ideal for GPU parallelization.

Each GPU thread simulated a separate income trajectory.

This allowed **millions of simulations to run simultaneously**.

---

## 2. Memory Optimization

The original CPU implementation stored large arrays of simulated outputs, which exceeded GPU memory limits.

To solve this, I implemented **online moment calculation algorithms**, allowing the system to compute statistics without storing full simulation histories.

---

## 3. One-Pass Moment Computation

Instead of storing all simulation results, the algorithm computed distribution statistics during simulation.

Using **parallel online algorithms**, the system calculated:

- variance
- skewness
- kurtosis

This approach dramatically reduced memory requirements and avoided expensive GPU memory transfers.

---

# Performance Improvements

The optimized CUDA implementation delivered major performance gains.

| Implementation | Runtime |
|---|---|
| CPU (single-thread) | ~90 seconds |
| CPU (36 threads OpenMP) | ~6 seconds |
| GPU (CUDA implementation) | **~20 milliseconds** |

Performance improvements:

- **4500× faster than single-thread CPU**
- **285× faster than multi-thread CPU**

These improvements made large-scale stochastic estimation practical.

---

# Impact

The optimized system enabled:

- Efficient estimation of realistic income processes
- Large-scale Monte Carlo simulation
- High-dimensional parameter estimation

The estimated stochastic process captured important empirical properties of income dynamics such as:

- heavy-tailed shock distributions
- persistent income shocks
- large but infrequent career shocks

These features are critical for **heterogeneous-agent macroeconomic models used in monetary policy analysis**.

---

# Key Techniques Used

- CUDA GPU programming
- Large-scale Monte Carlo simulation
- Parallel stochastic simulation
- Online statistical moment computation
- High-performance numerical algorithms
- Simulated method of moments estimation

---

# Relevance to Modern Modeling Systems

The techniques developed in this project are directly applicable to modern computational modeling problems such as:

- energy system simulations
- reservoir uncertainty analysis
- stochastic optimization
- probabilistic forecasting
- large-scale scenario simulation

Many of these problems require **running millions of simulations efficiently**, making GPU-based stochastic modeling extremely valuable.

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


---

# Reference

Karibzhanov, I. (2020).  
**Toward a HANK Model for Canada: Estimating a Canadian Income Process**.  
Bank of Canada Staff Discussion Paper 2020-13.

Paper: https://www.bankofcanada.ca/wp-content/uploads/2020/12/sdp2020-13.pdf