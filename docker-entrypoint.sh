#!/bin/bash
set -e

dir_shell=/ql/shell
. $dir_shell/share.sh
link_shell
echo -e "======================1. 检测配置文件========================\n"
fix_config
cp -fv $dir_root/docker/front.conf /etc/nginx/conf.d/front.conf
pm2 l >/dev/null 2>&1
echo

echo -e "======================2. 安装依赖========================\n"
update_depend
echo

echo -e "======================3. 启动nginx========================\n"
nginx -s reload 2>/dev/null || nginx -c /etc/nginx/nginx.conf
echo -e "nginx启动成功...\n"

echo -e "======================4. 启动控制面板========================\n"
if [[ $(pm2 info panel 2>/dev/null) ]]; then
  pm2 reload panel --source-map-support --time
else
  pm2 start $dir_root/build/app.js -n panel --source-map-support --time
fi
echo -e "控制面板启动成功...\n"

echo -e "======================5. 启动定时任务========================\n"
if [[ $(pm2 info schedule 2>/dev/null) ]]; then
  pm2 reload schedule --source-map-support --time
else
  pm2 start $dir_root/build/schedule.js -n schedule --source-map-support --time
fi
echo -e "定时任务启动成功...\n"

if [[ $AutoStartBot == true ]]; then
  echo -e "======================6. 启动bot========================\n"
  nohup ql bot >>$dir_log/start.log 2>&1 &
  echo -e "bot后台启动中...\n"
fi

if [[ $EnableExtraShell == true ]]; then
  echo -e "======================7. 执行自定义脚本========================\n"
  nohup ql extra >>$dir_log/start.log 2>&1 &
  echo -e "自定义脚本后台执行中...\n"
fi

if [[ $EnableNinjaDefault == true ]]; then
  echo -e "=============== 启动 Ninja for qinglong2.8.0+ ====================\n"
  cd /ql/ninja
  folder="/ql/ninja/backend"
  if [ ! -d "$folder" ]; then
    git clone https://github.com/MoonBegonia/ninja.git /ql/ninja
    cd /ql/ninja/backend
    pnpm install
    pm2 start
    cp sendNotify.js /ql/scripts/sendNotify.js
  else
    cd /ql/ninja/backend
    git checkout .
    git pull
    pnpm install
    pm2 start
    cp sendNotify.js /ql/scripts/sendNotify.js
  fi
  echo -e "Ninja启动成功...\n"
else
  echo -e "=============== 启动 JDC for qinglong2.8.0+ ====================\n"
  cd /ql/jdc/
  if [ ! -f "config.toml" ]; then
    cp -rf /ql/jdc_new/* ./
  fi
  arch=`arch`
  if [ $arch == 'x86_64' ]; then
    echo -e "run x86_64 JDC_NEW\n"
    nohup /ql/jdc/JDC_NEW &
  else
    echo -e "try run arm JDC_NEW\n"
    /ql/jdc/JDC_NEW_ARM64 &> /dev/nul
  fi
  echo -e "JDC启动成功...\n"
fi

echo -e "############################################################\n"
echo -e "容器启动成功..."
echo -e "\n请先访问5700端口，登录成功面板之后再执行添加定时任务..."
echo -e "############################################################\n"

cr ond -f >/dev/null

exec "$@"
