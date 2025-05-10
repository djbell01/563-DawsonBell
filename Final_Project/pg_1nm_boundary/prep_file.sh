#!/bin/bash
#SBATCH -p short #gpu-p100, shortgpu, shortgpu-p100, short, bsudfq, 
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=48
#SBATCH -t 30:00
#SBATCH -o log_slurm.o%j
#SBATCH -J Prep_vac
#  #SBATCH --exclusive

module unload gcc
module load gromacs
export OMP_NUM_THREADS=48
export GMXLIB=$HOME/GMXLIB
echo 15 | gmx_mpi pdb2gmx -f pg.pdb -o pg.gro -water tip4p
gmx_mpi editconf -f pg.gro -o box.gro -c -d 1.0 -bt cubic
gmx_mpi solvate -cp box.gro -cs tip4p -o conf.gro -p topol.top
