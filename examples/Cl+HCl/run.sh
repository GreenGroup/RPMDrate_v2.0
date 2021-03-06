for i in $(seq -0.05 0.01 1.05); do
#for i in 0.36 0.37 0.71 0.75 0.80 0.81; do 
echo '#!/usr/bin/env python ' > input"$i".py
echo '# encoding: utf-8 ' >> input"$i".py
echo '  ' >> input"$i".py
echo 'from PES import get_potential ' >> input"$i".py
echo '   ' >> input"$i".py
echo '################################################################################ ' >> input"$i".py
echo ' ' >> input"$i".py
echo 'from PES import get_potential, initialize_potential' >> input"$i".py
echo ' '>> input"$i".py
echo '################################################################################' >> input"$i".py
echo ' '>> input"$i".py
echo "label = 'Cl + HCl -> ClH + Cl' " >> input"$i".py
echo ' ' >> input"$i".py
echo 'reactants(  ' >> input"$i".py
echo "    atoms = ['Cl', 'H', 'Cl'], " >> input"$i".py
echo '    reactant1Atoms = [1], ' >> input"$i".py
echo '    reactant2Atoms = [2,3], ' >> input"$i".py
echo '    Rinf = (30,"bohr"), ' >> input"$i".py
echo ') ' >> input"$i".py
echo ' ' >> input"$i".py
echo 'transitionState( ' >> input"$i".py
echo '    geometry = ( ' >> input"$i".py
echo '        [[-2.772072758,   0.000,   0.000], ' >> input"$i".py
echo '         [0.000,    0.000,   0.000], ' >> input"$i".py
echo '         [2.772072758,    0.000,   0.000]], ' >> input"$i".py
echo '        "bohr", ' >> input"$i".py
echo '    ), ' >> input"$i".py
echo '    formingBonds = [(2,1)], ' >> input"$i".py
echo '    breakingBonds = [(3,2)], ' >> input"$i".py
echo ') ' >> input"$i".py
echo ' ' >> input"$i".py
echo '#equivalentTransitionState( ' >> input"$i".py
echo '#    formingBonds=[(3,1)],  ' >> input"$i".py
echo '#    breakingBonds=[(2,3)], ' >> input"$i".py
echo '#) ' >> input"$i".py
echo ' ' >> input"$i".py
echo "thermostat('Andersen') " >> input"$i".py
echo ' ' >> input"$i".py
echo '################################################################################# ' >> input"$i".py
echo ' ' >> input"$i".py
echo 'xi_list = numpy.arange(-0.05, 1.05, 0.01) ' >> input"$i".py
echo "#xi_list = [$i] " >> input"$i".py
echo ' ' >> input"$i".py
echo 'generateUmbrellaConfigurations( ' >> input"$i".py
echo '    dt = (0.0001,"ps"), ' >> input"$i".py
echo '    evolutionTime = (5,"ps"), ' >> input"$i".py
echo '    xi_list = xi_list, ' >> input"$i".py
echo '    kforce = 0.1 * T, ' >> input"$i".py
echo ') ' >> input"$i".py
echo ' ' >> input"$i".py
echo "xi_list = [$i] " >> input"$i".py
echo 'windows = [] ' >> input"$i".py
echo 'for xi in xi_list: ' >> input"$i".py
echo '    window = Window(xi=xi, kforce=0.1*T, trajectories=200, equilibrationTime=(20,"ps"), evolutionTime=(100,"ps")) ' >> input"$i".py
echo '    windows.append(window) ' >> input"$i".py
echo ' ' >> input"$i".py
echo 'conductUmbrellaSampling( ' >> input"$i".py
echo '    dt = (0.0001,"ps"), ' >> input"$i".py
echo '    windows = windows, ' >> input"$i".py
echo ') ' >> input"$i".py
echo ' ' >> input"$i".py
echo '#computePotentialOfMeanForce(windows=windows, xi_min=-0.02, xi_max=1.02, bins=5000) ' >> input"$i".py
echo ' ' >> input"$i".py
echo ' ' >> input"$i".py
echo '#computeRateCoefficient() ' >> input"$i".py
echo ' ' >> input"$i".py


echo '#!/bin/bash ' > submit"$i".sh
echo "#$ -o stdout_300_1_""$i"".txt" >> submit"$i".sh                                                                                                       
echo "#$ -e stderr_300_1_""$i"".txt" >> submit"$i".sh                                                                                                       
echo '#$ -j y ' >> submit"$i".sh                                                                                                                      
echo "#$ -N ClHCl""$i"" " >> submit"$i".sh                                                                                                             
echo '#$ -l h_rt=9996:00:00 ' >> submit"$i".sh                                                                                                        
echo '#$ -l mem_total=1G' >> submit"$i".sh
echo '#$ -l harpertown ' >> submit"$i".sh                                                                                                                  
#echo '#$ -q long5@node94' > submit"$i".sh
echo '#$ -pe singlenode 1' >> submit"$i".sh 

echo 'cd ' >> submit"$i".sh
echo 'source .bash_profile ' >> submit"$i".sh
echo 'source /opt/intel/Compiler/11.0/074/bin/intel64/ifortvars_intel64.sh ' >> submit"$i".sh
echo 'cd /home/ysuleyma/RPMDrate/ ' >> submit"$i".sh
echo "python rpmdrate.py /home/ysuleyma/RPMDrate/Examples/ClHClBCMR/input"$i".py 300 1 -p 1" >> submit"$i".sh
echo ' ' >> submit"$i".sh
qsub submit"$i".sh 
done 