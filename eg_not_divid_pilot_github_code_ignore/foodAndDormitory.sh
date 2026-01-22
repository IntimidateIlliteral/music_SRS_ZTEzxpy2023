
# source "$HOME/.bashrc"
# bash ./foodAndDormitory.sh


# input0=1

input1=false

NUM_INSTANCES=3

# for ((input0=1; input0<=$NUM_INSTANCES; input0++)); do
#    matlab -nodesktop -nosplash -r "linux_input_column = $input0;linux_input_toggle = $input1; runMe4linux;exit" &
# done

# echo "Started $NUM_INSTANCES MATLAB instances in background."


for ((input0=1; input0<=$NUM_INSTANCES; input0++)); do
# 如果不开多窗口，则matlab在计算出结果disp()后，不会exit，原因未知。
    gnome-terminal -- bash -c "
        matlab -nodesktop -nosplash \
            -r \"linux_input_column=$input0; linux_input_toggle=logical($input1); runMe4linux; exit\"
    "
done
