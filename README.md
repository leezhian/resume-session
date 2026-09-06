# resume-session

把 Claude Code、Codex、Cursor、Qoder CLI、Grok、ZCode 的会话接续到当前 agent，作为只读历史继续工作。不会自动安装，按下面方式自行安装。

## 支持功能

| Skill | 用途 |
| --- | --- |
| `resume-claude` | 接续 Claude Code 会话 |
| `resume-codex` | 接续 Codex CLI / VS Code 会话 |
| `resume-cursor` | 接续 Cursor CLI / Desktop 会话 |
| `resume-qoder` | 接续 Qoder CLI 会话 |
| `resume-grok` | 接续 Grok 会话 |
| `resume-zcode` | 接续 ZCode 会话 |

- 不传参数或传 `latest`：接续当前目录最近一次会话
- 传会话 ID、transcript 路径、或描述文字：按匹配结果接续
- 匹配不唯一时列出候选，不会猜测
- 安装后可用 `/resume-claude`、`/resume-codex`、`/resume-zcode` 等命令，或直接说 “continue from Claude / Codex / Cursor / Qoder / Grok / ZCode”

Qoder 目前只支持 CLI 会话，不支持 Qoder IDE。

可用的 agent：Claude Code、Codex、OpenCode、Pi、Grok、Cursor。

## 安装

### 推荐：`install.sh`

```bash
chmod +x install.sh

# 用户级（默认，符号链接）
./install.sh --user

# 仅当前项目
./install.sh --project /path/to/your-repo

# 只装指定 agent，复制而不是链接
./install.sh --user --copy --agents claude,codex

# 只装部分 skill
./install.sh --user --skills qoder,grok

# 卸载指定 skill
./install.sh --user --skills qoder,grok --uninstall

# 卸载本包安装的全部 skill
./install.sh --user --uninstall
```

`--agents` 可选：`grok`、`claude`、`codex`、`opencode`、`pi`、`cursor`、`all`。

安装完成后新开一个 agent 会话即可使用。

### 各 agent 插件安装（可选）

**Claude Code**

```bash
claude plugin marketplace add /path/to/resume-plugin
claude plugin install resume-session
```

**Codex**

```bash
codex plugin marketplace add /path/to/resume-plugin
```

然后从插件列表安装 `resume-session`。

**Grok**

```bash
grok plugin marketplace add /path/to/resume-plugin
grok plugin install resume-session --trust
grok plugin enable resume-session
```

或：

```bash
grok plugin install /path/to/resume-plugin --trust
```

**Pi**

```bash
pi install /path/to/resume-plugin
```

**OpenCode**

使用上面的 `install.sh`。
