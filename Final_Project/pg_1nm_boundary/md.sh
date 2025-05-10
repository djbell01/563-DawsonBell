#!/bin/bash
#SBATCH -p bsudfq #gpu-p100, shortgpu, shortgpu-p100, short, bsudfq, 
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=48
#SBATCH -t 5:00:00
#SBATCH -o log_slurm.o%j
#SBATCH -J 2FS
#  #SBATCH --exclusive

module unload gcc
module load gromacs
export OMP_NUM_THREADS=48
export GMXLIB=$HOME/GMXLIB

mpirun -np 1 -npernode 48 gmx_mpi grompp -f mdp/min.mdp -c conf.gro -p topol.top -o min.tpr
mpirun -np 1 -npernode 48 gmx_mpi mdrun -v -deffnm min

mpirun -np 1 -npernode 48 gmx_mpi grompp -f mdp/min2.mdp -c min.gro -r min.gro -p topol.top -o min2.tpr
mpirun -np 1 -npernode 48 gmx_mpi mdrun -v -deffnm min2

mpirun -np 1 -npernode 48 gmx_mpi grompp -f mdp/eql.mdp -c min2.gro -r min2.gro -p topol.top -o eql.tpr
mpirun -np 1 -npernode 48 gmx_mpi mdrun -v -deffnm eql

mpirun -np 1 -npernode 48 gmx_mpi grompp -f mdp/eql2.mdp -c eql.gro -r eql.gro -p topol.top -o eql2.tpr
mpirun -np 1 -npernode 48 gmx_mpi mdrun -v -deffnm eql2

mpirun -np 1 -npernode 48 gmx_mpi grompp -f mdp/prd.mdp -c eql2.gro -r eql2.gro -p topol.top -o prd.tpr
mpirun -np 1 -npernode 48 gmx_mpi mdrun -v -deffnm prd
