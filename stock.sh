#!/bin/bash
echo "*************stock tool**************"
url="http://hq.sinajs.cn/list="
printf "%-15s|" "名称"
printf "%-15s|" "当前"
printf "%-15s|" "涨幅(%)"
printf "%-15s|" "昨收"
printf "%-15s|" "今开"
printf "%-20s|" "当日最高"
printf "%-20s|" "当日最低"
printf "%-20s|" "成交数(手)"
printf "%-20s|\n" "成交额(万元)"
for line in `cat ./conf.ini`
do
	tmp=`curl -H "Referer:https://finance.sina.com.cn" -s "${url}${line}" | iconv -f gb2312`
	#echo $tmp
	str=`echo ${tmp#*\"}`
	#echo $str
	str=`echo ${str%%\"*}`
	#echo $str
	name=`echo $str| awk -F ',' '{print $1}'`
	init_price=`echo $str| awk -F ',' '{print $2}'`
	yesterday_price=`echo $str| awk -F ',' '{print $3}'`
	current_price=`echo $str| awk -F ',' '{print $4}'`
	top_price=`echo $str| awk -F ',' '{print $5}'`
	end_price=`echo $str| awk -F ',' '{print $6}'`
	deal_num=`echo $str| awk -F ',' '{print $9}'`
	deal_amount=`echo $str| awk -F ',' '{print $10}'`
	deal_date=`echo $str| awk -F ',' '{print $31}'`
	deal_time=`echo $str| awk -F ',' '{print $32}'`
	#计算涨幅
	#surplus=$(($current_price-$yesterday_price))
	#rate=$(($surplus/$yesterday_price))
	surplus=`echo "scale=3; $current_price - $yesterday_price" |bc`
	rate=`echo "scale=2; $surplus*100/$yesterday_price" | bc`
	deal_num2=`echo "scale=2; $deal_num/100" | bc`
	deal_amount2=`echo "scale=2; $deal_amount/10000" | bc`
	printf "%-17s|" $name
	printf "%-13s|" $current_price
	printf "%-13s|" $rate
	printf "%-13s|" $yesterday_price
	printf "%-13s|" $init_price
	printf "%-16s|" $top_price
	printf "%-16s|" $end_price
	printf "%-16s|" $deal_num2
	printf "%-15s|\n" $deal_amount2
done
echo 
