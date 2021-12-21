#!/bin/bash
# 修复分片为0的索引
IFS=$'\n'
NODE='master'
xiufu(){
    echo -e '\n开始尝试修复'
    for line in `curl -s http://10.0.2.245:9200/_cat/shards | fgrep UNASSIGNED`; do
      INDEX=$(echo $line | (awk 'BEGIN{FS=" "}END{print $1}'))
      SHARD=$(echo $line | (awk 'BEGIN{FS=" "}END{print $2}'))
      curl -H 'Content-Type: application/json' -XPOST 'http://10.0.2.245:9200/ster/reroute' -d '{
        "commands": [
            {
                "allocate_stale_primary": {
                    "index": "'$INDEX'",
                     "shard": '$SHARD',
                    "node": "'$NODE'",
                    "accept_data_loss": true
                }
            } 
        ]
     }'
    done
}

delete(){
    echo -e '\n开始尝试删除'
    for line in `curl -s http://10.0.2.245:9200/_cat/shards | fgrep UNASSIGNED`; do
      index=$(echo $line | (awk 'BEGIN{FS=" "}END{print $1}'))
      echo "开始删除 ${index} 索引"
      curl -XDELETE http://10.0.2.245:9200/${index}
    done
}

echo '1.修复'
echo '2.删除'
read -p '请选择修复或者删除分片为0的索引: ' -n 1 choice

case $choice in 
1)
  xiufu
  ;;
2)
  delete
  ;;
*)
  echo '输入错误,脚本退出'
  exit
  ;;
esac
