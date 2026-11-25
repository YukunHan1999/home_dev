# 1. 主要解决的问题

```plaintext
因为网络问题无法解决, 本地代码仓库code_repo, 镜像仓库image_repo 等其他服务在各自的网络中，统一使用docker network 来进行管理。
docker network ls
docker network create <net_name>
docker network connect <net_name> <container_name>
docker network disconnect <net_name> <container_name>
# 自建的网络可以根据容器名映射IP地址 
但是主机网络无法通过容器名动态映射容器IP地址, 为了统一处理，需要自建一个客户端，可以连接code_repo, image_repo负责提交代码，推送镜像, 相当于在容器中玩docker outside of docker.

# 弃用code_repo, 改容器名为hyk.com, 放弃挂在端口到外部，直接使用X11 socket文件从内部打开浏览器到外部
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install ./google-chrome-stable_current_amd64.deb -y

sudo google-chrome --no-sandbox
```
