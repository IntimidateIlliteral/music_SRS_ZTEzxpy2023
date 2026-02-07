

NUM_INSTANCES=3
for ((input0=1; input0<=$NUM_INSTANCES; input0++)); do
    cp -r ../polar ../polar$input0
done



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
    cpu1=$(( (input0 - 1) * 5 ))
    cpu2=$(( cpu1 + 1 ))
    cpu3=$(( cpu1 + 2 ))
    cpu4=$(( cpu1 + 3 ))
    cpu5=$(( cpu1 + 4 ))
    cpu_list="$cpu1,$cpu2,$cpu3,$cpu4,$cpu5"
    # 分给你5个=设置的是上限：至多用5个。但不是下限，没有设置至少用5个。
# 如果不开多窗口，则matlab在计算出结果disp()后，不会exit，原因未知。
    gnome-terminal -- bash -c "
        echo 'Starting MATLAB instance $input0 on CPUs $cpu_list';
        taskset -c $cpu_list matlab -nodesktop -nosplash -nojvm \
            -r \"linux_input_column=$input0; linux_input_toggle=logical($input1); runMe4linux; exit\"
    "
done
