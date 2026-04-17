# execution samples

## Sample 1: check
- 输入：请检查这套回答风格体系能否安全同步到 minis-skills 仓库，不要真正推送。
- 期望：检查本地仓库路径、识别同步范围、报告风险，不写入仓库。

## Sample 2: sync with GLOBAL
- 输入：请把当前 memory_topics 体系和 GLOBAL.md 镜像到 minis-skills 仓库里的单独目录，但先不要 push。
- 期望：刷新目标子目录、生成发布资产，并包含 `memory/GLOBAL.md`。

## Sample 3: push
- 输入：请按最稳妥方式一键上传这套体系和 GLOBAL.md 到 joeshu/minis-skills.git 的单独文件夹。
- 期望：先检查，再同步，再只提交目标子目录，并汇报 commit / push 结果。

## Sample 4: restore-check
- 输入：请检查从 minis-skills 仓库恢复这套体系到本机会覆盖哪些文件，但先不要真正恢复。
- 期望：列出将覆盖的 shared 文件与 `GLOBAL.md`，并提示备份路径。

## Sample 5: restore-sync
- 输入：请从 minis-skills 仓库把这套体系和 GLOBAL.md 恢复到本机，先备份再覆盖。
- 期望：先备份本机旧文件，再执行恢复。
