# 管理

```bash
# 自签名证书
openssl req -new -x509 -sha256 -days 365 -nodes \
  -out nginx/certs/hyk.crt \
  -keyout nginx/certs/hyk.key \
  -subj "/C=CN/ST=Shanghai/L=Shanghai/O=YuKun/OU=Dev/CN=hyk.com"

# 清理volume
docker-compose down
docker-compose down -v
# 重新构建
docker-compose up -d

# 测试 测试之前记得unset ALL_PROXY
bash ./script/test_single_clear.sh
```
