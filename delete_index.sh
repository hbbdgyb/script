#!/bin/sh
#此脚本用于删除es历史数据
delrange(){
	#删除的索引项目
	index_name=("auditbeat-hxtpayment" "auditbeat-hxtpay" "go-mobileposp")
	#根据哪一列查找关键词
	daycolumn="@timestamp"
	#删除几条之前的数据
	savedays=5
	#日期格式
	format_day="%Y-%m-%d"
	#计算savedays之前的日期
	sevendayago=`date -d "-${savedays} day " +${format_day}`

	for index in ${index_name[@]} 
	do
	curl --user elastic:z7mqJpZO1rvOYUPkUiZy -X POST "http://192.168.80.11:9200/${index}/_delete_by_query" -H 'Content-Type: application/json' -d'
	{
		"query": { 
			"range": {
				"'"$daycolumn"'": {
					"lt": "'"$sevendayago"'"
				}
			}
		}
	}
	'
	done
}



#删除es几天前的数据
delday(){
	#日期格式
	format_day="%Y.%m.%d"
	#删除几天之前的数据
	savedays=14
	#计算savedays之前的日期
	sevendayago=`date -d "-${savedays} day " +${format_day}`
	for index in `curl -XGET "http://10.0.2.245:9200/_cat/indices" |awk '{print $3}'|grep ${sevendayago} |sort`
	do 
		#echo ${index%-*}
		curl -XDELETE http://192.168.80.11:9200/${index}-${sevendayago}
	done
}

delmonth(){
	#日期格式
	format_day="%Y.%m"
	#删除几天之前的数据
	savedays=90
	#计算savedays之前的日期
	sevenmonago=`date -d "-${savedays} day " +${format_day}`
	index_month=("centos" "cisco")
	#删除几个月前
	for index in ${index_month[@]}
	do
		curl --user elastic:z7mqJpZO1rvOYUPkUiZy -XDELETE http://192.168.80.11:9200/${index}-${sevenmonago}
	done
}

#删除单个
#curl -XDELETE 'http://192.169.1.666:9200/index
#删除多个
#curl -XDELETE 'http://192.169.1.666:9200/index_one,index_two


delday
