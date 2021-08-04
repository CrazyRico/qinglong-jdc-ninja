# qinglong-jdc-ninja
青龙2.8.0+jdc_new+ninja集成环境


# 构建
```shell
$ docker build -t crazyrico/qinglong-jdc-ninja .
```

# 启动容器
```shell
$ docker run -dit \
  --name qinglong \
  --hostname ql \
  --restart always \
  -p 5700:5700 \
  -p 5701:5701 \
  -v /home/docker/ql/config:/ql/config \
  -v /home/docker/ql/log:/ql/log \
  -v /home/docker/ql/db:/ql/db \
  -v /home/docker/ql/scripts:/ql/scripts \
  -v /home/docker/ql/jbot:/ql/jbot \
  -v /home/docker/ql/jdc:/ql/jdc \
  -v /home/docker/ql/ninja:/ql/ninja \
  crazyrico/qinglong-jdc-ninja
```

# 配置
默认启动jdc_new 作为获取ck工具，可在/ql/config/config.sh中添加,启用ninja
```shell
EnableNinjaDefault=true
```

# 说明
本构建镜像仅供学习参考使用，请于下载后的 24 小时内删除，本人不对使用过程中出现的任何问题负责，包括但不限于 数据丢失 数据泄露。
