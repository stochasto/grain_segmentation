[[ -r /apps/3rdparty/hpcrnd/envmodules/profile.d/shell-modules.sh ]] && . /apps/3rdparty/hpcrnd/envmodules/profile.d/shell-modules.sh
[[ -r /apps/3rdparty/hpcrnd/envmodules/profile.d/hpc-modules.sh ]] && . /apps/3rdparty/hpcrnd/envmodules/profile.d/hpc-modules.sh
#BSUB -J ellipse
#BSUB -n 1
#BSUB -x
#BSUB -P pti-ca
#BSUB -W 200:00
#BSUB -eo err.%J
#BSUB -oo ellipse.%J
#BSUB -L /bin/bash


matlab -v2019a -nodisplay -nosplash < runner.m > out.dat

