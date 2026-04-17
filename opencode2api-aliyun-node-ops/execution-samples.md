# opencode2api-aliyun-node-ops 执行样本

用途：记录一次真实的 Open Minis 本地开发 → Git 推送 → 阿里云服务器部署/验证/回滚/发布汇报过程，作为后续回归与维护样本。

## 建议记录字段
- 日期
- 任务类型（本地改动 / push / deploy / smoke / rollback / report）
- 本地仓库路径（workspace / shared）
- 改动类型
- 本地验证结果
- Git 信息（branch / commit / message）
- GitHub Actions 结果
- 服务器动作
- 健康检查结果
- API 冒烟结果
- 是否需要回滚
- 最终结果质量评估
- 备注

## 样本模板
```md
### Sample N
- 日期：YYYY-MM-DD
- 任务类型：
- 本地仓库路径：
- 改动类型：
- 本地验证结果：
- Git 信息：
- GitHub Actions 结果：
- 服务器动作：
- 健康检查结果：
- API 冒烟结果：
- 是否需要回滚：是 / 否
- 最终结果质量评估：好 / 一般 / 差
- 备注：
```

## 真实样本建议覆盖
1. 本地小改动 + smoke + push
2. Actions 全绿后服务器部署验证
3. ready 异常排障
4. chat/responses 主链路远程冒烟
5. 发布后紧急回滚
6. 正式发布汇报
