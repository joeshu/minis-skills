# make-ipa

用于为 iOS SwiftUI / XcodeGen 项目创建和维护未签名 IPA 构建流程。

## 主要能力
- 首轮打通 GitHub Actions 未签名 IPA 流水线
- 后续迭代时优先只改代码，不轻易改 workflow
- 查询 GitHub Actions 构建状态
- 下载成功构建的 IPA
- 下载失败构建日志并辅助定位问题

## 关键文件
- `SKILL.md`：技能主说明
- `test-prompts.json`：测试提示样例
- `references/mode_detect.sh`：判定模式 A/B
- `references/check_actions.sh`：查询 Actions runs
- `references/download_ipa.sh`：下载 IPA
- `references/download_build_log.sh`：下载失败日志

## 使用示例
```sh
sh references/mode_detect.sh /path/to/repo
sh references/check_actions.sh <owner> <repo>
sh references/download_ipa.sh <owner> <repo>
sh references/download_build_log.sh <owner> <repo>
```
