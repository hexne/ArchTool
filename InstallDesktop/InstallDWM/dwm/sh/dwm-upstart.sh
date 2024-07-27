#!bin/bash

# hddN="/dev/mapper/control" # 显示磁盘剩余容量的磁盘

# 计算CPU使用率(上一秒)
# CPU使用率计算公式：CPU_USAGE=(IDLE2-IDLE1) / (CPU_TIME2-CPU_TIME1) * 100
# CPU_TIME计算公式 ：CPU_TIME=user + system + nice + idle + iowait + irq + softirq
PRE_CPU_INFO=$(cat /proc/stat | grep -w cpu | awk '{print $2,$3,$4,$5,$6,$7,$8}')
IDLE1=$(echo $PRE_CPU_INFO | awk '{print $4}')
CPU_TIME1=$(echo $PRE_CPU_INFO | awk '{print $1+$2+$3+$4+$5+$6+$7}')

# 计算上传下载的速率(上一秒)
# 获取所有网卡的接收速率
PRE_RX=$(cat /proc/net/dev | sed 's/:/ /g' | awk '{print $2}' | grep -v [^0-9])
PRE_RX_SUM=0
for i in ${PRE_RX}
do
# 计算所有网卡的接收速率的总和
PRE_RX_SUM=$(expr ${PRE_RX_SUM} + ${i})
done
# 获取所有网卡的发送速率
PRE_TX=$(cat /proc/net/dev | sed 's/:/ /g' | awk '{print $10}' | grep -v [^0-9])
PRE_TX_SUM=0
for i in ${PRE_TX}
do
# 计算所有网卡的发送速率的总和
PRE_TX_SUM=$(expr ${PRE_TX_SUM} + ${i})
done

sleep 1
# 计算CPU使用率(下一秒)
NEXT_CPU_INFO=$(cat /proc/stat | grep -w cpu | awk '{print $2,$3,$4,$5,$6,$7,$8}')
IDLE2=$(echo $NEXT_CPU_INFO | awk '{print $4}')
CPU_TIME2=$(echo $NEXT_CPU_INFO | awk '{print $1+$2+$3+$4+$5+$6+$7}')
# (IDLE2 - IDLE1)
SYSTEM_IDLE=`echo ${IDLE2} ${IDLE1} | awk '{print $1-$2}'`
# (CPU_TIME2 - CPU_TIME1)
TOTAL_TIME=`echo ${CPU_TIME2} ${CPU_TIME1} | awk '{print $1-$2}'`
# (IDLE2-IDLE1) / (CPU_TIME2-CPU_TIME1) * 100
CPU_USAGE=`echo ${SYSTEM_IDLE} ${TOTAL_TIME} | awk '{printf "%.2f", 100-$1/$2*100}'`

# 计算上传下载的速率(下一秒)
# 获取所有网卡的接收速率
NEXT_RX=$(cat /proc/net/dev | sed 's/:/ /g' | awk '{print $2}' | grep -v [^0-9])
NEXT_RX_SUM=0
for i in ${NEXT_RX}
do
# 计算所有网卡的接收速率的总和
NEXT_RX_SUM=$(expr ${NEXT_RX_SUM} + ${i})
done
# 获取所有网卡的发送速率
NEXT_TX=$(cat /proc/net/dev | sed 's/:/ /g' | awk '{print $10}' | grep -v [^0-9])
NEXT_TX_SUM=0
for i in ${NEXT_TX}
do
# 计算所有网卡的发送速率的总和
NEXT_TX_SUM=$(expr ${NEXT_TX_SUM} + ${i})
done

# 计算两次的差,这就是一秒内发送和接收的速率
RX=$((${NEXT_RX_SUM}-${PRE_RX_SUM}))
TX=$((${NEXT_TX_SUM}-${PRE_TX_SUM}))

# 换算单位
if [[ $RX -eq 0 ]];then
# 如果接收速率于0,则单位为0KB/s
RX="0KB/s"
elif [[ $RX -lt 1024 ]];then
# 如果接收速率小于1024,则单位为1KB/s
RX="1KB/s"
elif [[ $RX -gt 1048576 ]];then
# 否则如果接收速率大于 1048576,则改变单位为MB/s
RX=$(echo $RX | awk '{printf "%.2fMB/s",$1/1048576}')
else
# 否则如果接收速率大于1024但小于1048576,则单位为KB/s
RX=$(echo $RX | awk '{printf "%.2fKB/s",$1/1024}')
fi

# 换算单位
if [[ $TX -eq 0 ]];then
# 如果接收速率于0,则单位为0KB/s
TX="0KB/s"
elif [[ $TX -lt 1024 ]];then
# 如果发送速率小于1024,则单位为1KB/s
TX="1KB/s"
elif [[ $TX -gt 1048576 ]];then
# 否则如果发送速率大于 1048576,则改变单位为MB/s
TX=$(echo $TX | awk '{printf "%.2fMB/s",$1/1048576}')
else
# 否则如果发送速率大于1024但小于1048576,则单位为KB/s
TX=$(echo $TX | awk '{printf "%.2fKB/s",$1/1024}')
fi



# DiSK
DISKREAD=$(iostat sda | awk 'NR==7 { print $3 }')
DISKWRITE=$(iostat sda | awk 'NR==7 { print $4 }')

DISKREAD=$(echo "$DISKREAD/1024"|bc)
DISKWRITE=$(echo "$DISKWRITE/1024"|bc)
# DISKREAD=$(echo "scale=2;$DISKREAD/10"|bc)
# DISKWRITE=$(echo "scale=2;$DISKWRITE/10"|bc)
SOUND=$(amixer get Master | grep -o "\\[[0-9]\{1,3\}%\\]" | grep -o "[0-9]\{1,3\}")

LOCALTIME=$(date +'Time:%m/%d %H:%M:%S')
IP=$(for i in `ip r`; do echo $i; done | grep -A 1 src | tail -n1) # can get confused if you use vmware
BAT="$( acpi -b | awk '{ print $4 }' | tr -d ',' )"
#HDDFREE=$(df -Ph ${hddN} | awk '$3 ~ /[0-9]+/ {print $4}')
MEMFREE=$(free -h|awk '{print $7}'|awk 'NR==2')
if acpi -a | grep off-line > /dev/null
then
# 如果没插上电源则显示电池图标
#xsetroot -name " D:$RX U:$TX Cpu:$CPU_USAGE% Hdd:$HDDFREE Mem:$MEMFREE Ip:$IP -$BAT $LOCALTIME"
xsetroot -name "RD:$DISKREAD WD:$DISKWRITE $Fnums D:$RX U:$TX Cpu:$CPU_USAGE% Mem:$MEMFREE Ip:$IP +[$BAT] $LOCALTIME"
else
# 否则如果插上了电源则显示电线图标
xsetroot -name "RD:"$DISKREAD"MB/s WD:"$DISKWRITE"MB/s ⬇:$RX ⬆:$TX S:$SOUND% Cpu:$CPU_USAGE% Mem:$MEMFREE Ip:$IP ♈[$BAT] $LOCALTIME"

fi
