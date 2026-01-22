
# source "$HOME/.bashrc"
# matlabCMD


input0=1

input1=false

# note that you may have a different MATLAB $PATH
"$HOME/SBYfood/software/matlabColumnVector/bin/matlab" -nodesktop -nosplash -r "linux_input_column = $input0;linux_input_toggle = $input1; runMe4linux;quit"
