#!/bin/bash
#SBATCH --job-name=HANK
#SBATCH --mail-type=END
#SBATCH --gres=gpu:1
#SBATCH --output=estimate.%j.out
#SBATCH --error=estimate.%j.err

./estimate
