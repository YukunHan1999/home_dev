#!/bin/bash
# test-registry-gc.sh - 兼容 HTTPS/HTTP + 自签名证书 + 认证

set -e  # 遇错立即退出

# 🔧 配置区域（按需修改）
REGISTRY_HOST="hyk.com"
REGISTRY_PROTO="https"                    # 改为 http 如果不用 TLS
REGISTRY_URL="${REGISTRY_PROTO}://${REGISTRY_HOST}"
REPO="test-image"
TAG_PREFIX="${REGISTRY_HOST}"
CERT_PATH="/etc/docker/certs.d/${REGISTRY_HOST}/ca.crt"  # CA 证书路径
AUTH="admin:123456.abc"                   # 用户名:密码，无认证则留空

# 🔐 CURL 通用参数（自动处理证书）
if [[ "$REGISTRY_PROTO" == "https" ]]; then
    if [[ -f "$CERT_PATH" ]]; then
        CURL_CERT="--cacert $CERT_PATH"
    else
        echo "⚠️ 警告: 未找到 CA 证书 $CERT_PATH，使用 --insecure 模式"
        CURL_CERT="-k"
    fi
else
    CURL_CERT=""
fi

# 🔐 认证参数
if [[ -n "$AUTH" ]]; then
    CURL_AUTH="-u $AUTH"
else
    CURL_AUTH=""
fi

# 组合 curl 基础命令
CURL_BASE="curl -s $CURL_CERT $CURL_AUTH"

echo "🧪 Registry 垃圾回收测试"
echo "========================"
echo "Registry: $REGISTRY_URL"
echo "证书模式: ${CURL_CERT:-无}"
echo "认证: ${AUTH:-无}"
echo ""

# 📦 1. 推送测试镜像
echo "1. 推送测试镜像..."
docker pull alpine:latest
docker tag alpine:latest ${TAG_PREFIX}/${REPO}:v1
docker push ${TAG_PREFIX}/${REPO}:v1

docker tag alpine:latest ${TAG_PREFIX}/${REPO}:v2
docker push ${TAG_PREFIX}/${REPO}:v2

echo "📊 推送后存储占用:"
du -sh ${PWD}/registry/data 2>/dev/null || echo "  (路径不存在或无权限)"

# 🏷️ 2. 查看标签列表
echo -e "\n2. 当前标签："
$CURL_BASE $REGISTRY_URL/v2/$REPO/tags/list | jq -R . 2>/dev/null || echo "  (jq 未安装或请求失败)"

# 🗑️ 3. 删除 v1 标签的 manifest
echo -e "\n3. 删除 v1 标签的 manifest..."

echo "$CURL_BASE -I -H 'Accept: application/vnd.docker.distribution.manifest.v2+json' $REGISTRY_URL/v2/$REPO/manifests/v1"

# 3.1 先获取 manifest 的 digest（必须用 HEAD + 正确 Accept 头）
DIGEST=$($CURL_BASE -I \
  -H "Accept: application/vnd.docker.distribution.manifest.v2+json" \
  $REGISTRY_URL/v2/$REPO/manifests/v1 \
  | grep -i Docker-Content-Digest \
  | awk '{print $2}' | tr -d '\r\n ')

if [[ -z "$DIGEST" ]]; then
    echo "❌ 无法获取 v1 的 digest，检查: 1)认证 2)证书 3)标签是否存在"
    exit 1
fi
echo "   获取到 digest: $DIGEST"

# 3.2 执行 DELETE（必须用相同 Accept 头）
DELETE_RESP=$($CURL_BASE -X DELETE \
  -H "Accept: application/vnd.docker.distribution.manifest.v2+json" \
  -w "\n%{http_code}" \
  $REGISTRY_URL/v2/$REPO/manifests/$DIGEST)

HTTP_CODE=$(echo "$DELETE_RESP" | tail -1)
if [[ "$HTTP_CODE" == "202" ]]; then
    echo "   ✅ 删除请求成功 (202)"
else
    echo "   ⚠️ 删除响应码: $HTTP_CODE"
    echo "$DELETE_RESP" | head -n -1
fi

# ✅ 4. 验证标签已删除
echo -e "\n4. 删除后标签列表："
$CURL_BASE $REGISTRY_URL/v2/$REPO/tags/list | jq -R . 2>/dev/null || echo "  (请求失败)"

# ♻️ 5. 执行垃圾回收（必须先停注册表）
echo -e "\n5. 执行垃圾回收..."
echo "   停止 registry 容器..."
docker stop image_repo_registry 2>/dev/null || true

echo "   运行 garbage-collect..."
docker run --rm \
  -v ${PWD}/registry/config:/etc/docker/registry/ \
  -v ${PWD}/registry/data:/var/lib/registry \
  registry:2 \
  garbage-collect --delete-untagged /etc/docker/registry/config.yml

echo "   重启 registry 容器..."
docker start image_repo_registry

# 📊 6. 检查磁盘变化
echo -e "\n6. GC 后存储占用:"
du -sh ${PWD}/registry/data 2>/dev/null || echo "  (路径不存在或无权限)"

echo -e "\n✅ 测试完成"

