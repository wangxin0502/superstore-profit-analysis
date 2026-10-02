---
AIGC:
    Label: "1"
    ContentProducer: 001191110102MACQD9K64018705
    ProduceID: 1694768359279929_0-drive/221912581520746833/README_本人版.md
    ReservedCode1: ""
    ContentPropagator: 001191110102MACQD9K64028705
    PropagateID: 1694768359279929#1790926092307
    ReservedCode2: ""
---
# 🏪 Superstore 超市利润诊断分析

> 基于 4 年、9,994 笔订单、800 位客户数据，按照「SQL → Python EDA → RFM 分群 → FineBI 看板」的流程，独立完成的端到端数据分析项目。
>
> 🔗 **在线交互看板**：[FineBI 利润看板](https://demo.fanruan.com/webroot/decision/link/Nt0z)　|　📄 **完整报告**：[分析报告.pdf](https://github.com/wangxin0502/superstore-profit-analysis/raw/main/%E5%88%86%E6%9E%90%E6%8A%A5%E5%91%8A.pdf)（点击直接打开/下载）

![SQL](https://img.shields.io/badge/SQL-MySQL%20%2F%20SQLite-4479A1) ![Python](https://img.shields.io/badge/Python-pandas-3776AB) ![BI](https://img.shields.io/badge/BI-FineBI-26B99A)

---

## 📌 项目简介

公司四年累计销售 410.4 万美元、毛利 67.0 万美元，整体毛利率 16.3%，基本盘健康，但 2018 年销售额同比下滑 1.94%、增长停滞。本项目通过逐层下钻定位原因，**最终发现问题不在地区，而在「大件家具 + 深度折扣」这一组合**，并通过 RFM 识别出流失风险客户，给出可执行建议。

## 🔑 核心发现

1. **亏损高度集中于家具类**：家具大类净亏 3.5 万美元，是唯一亏损大类；其中 Tables（桌子）亏 7.6 万、Bookcases（书柜）亏 1.7 万，而 Chairs、Furnishings 实际盈利。
2. **30% 是毛利分水岭**：折扣 ≤30% 时毛利率约 20%，≥50% 深折时降至 -12.2%；深折亏损几乎全部来自桌子、书柜、收纳——其他品类即便五折仍盈利。
3. **近三成客户流失预警**：234 位客户（29.2%）进入流失池，其中 50 位高价值的"重要挽留客户"曾贡献 39.9 万美元。

## 📂 仓库结构（按我的完成流程组织）

```
.
├── README.md                  # 项目说明（本文件）
├── 分析报告.pdf                # 完整业务分析报告
├── P1 SQL/                    # 第一阶段：数据库与 SQL 分析
│   ├── Script-超市利润.sql      # 建库、导入与 8 个业务查询
│   ├── superstore.csv          # 原始数据
│   ├── superstore.db           # 导入后的 SQLite 数据库
│   └── 数据字典.md              # 字段说明
├── P2 Python 数据清洗 + EDA/   # 第二阶段：Python 探索性分析
│   ├── P2_EDA分析.ipynb         # EDA 全过程：清洗 / 趋势 / 品类 / 折扣
│   ├── superstore.csv
│   ├── chart1_yearly.png       # 年度销售与利润
│   ├── chart2_subcat.png       # 子品类利润
│   ├── chart3_monthly.png      # 月度季节性
│   ├── chart4_discount.png     # 折扣区间利润
│   └── chart5_segment.png      # 分段分析
└── P3 RFM 客户分层/            # 第三阶段：客户分群
    ├── P3_RFM客户分群.ipynb         # RFM 建模完整过程
    ├── rfm_result.csv           # 800 位客户的 RFM 打分明细
    ├── RFM客户分群汇总.csv       # 8 类客户的汇总统计
    ├── rfm_segment_dist.png     # 客户分群分布图
    └── superstore.csv
```

> 第四阶段的 FineBI 看板为在线作品（见顶部链接），第五阶段产出即 `分析报告.pdf`。

## 🛠 使用工具与方法

| 阶段      | 工具                  | 完成内容                          |
| ------- | ------------------- | ----------------------------- |
| P1 数据提取 | SQL（MySQL / SQLite） | 建库导入、8 个业务查询（聚合、条件聚合、分组、时间函数） |
| P2 探索分析 | Python（pandas）      | 数据清洗、EDA、趋势 / 品类 / 折扣 / 季节性分析 |
| P3 客户建模 | RFM                 | R / F / M 三维打分，800 位客户分为 8 群  |
| P4 可视化  | FineBI              | 6 组件交互看板、3 个筛选器作用域设计、发布公开链接   |
| 方法论     | SCQA / MECE         | 结论先行，逐层排除（地区 → 大类 → 子品类 → 折扣） |

## ✨ 项目亮点

- **完整工作流闭环**：从手写 SQL 提数，到 Python 分析、RFM 建模、FineBI 看板发布，覆盖数据分析真实工作链路。
- **规范的指标口径**：比率坚持 `SUM(Profit)/SUM(Sales)` 先汇总再相除，不直接平均行级比率；KPI 固定 2018 年口径、RFM 使用全周期口径，保证口径一致。
- **结论皆有数据支撑**：每条业务建议都对应量化发现，避免空泛表述。

## ▶️ 复现方式

1. 参考 `P1 SQL/Script-超市利润.sql` 建库并导入 `superstore.csv`。
2. 依次运行 `P2`、`P3` 中的 Jupyter Notebook，即可得到分析图表与 RFM 结果。
3. 看板可直接通过顶部 FineBI 链接访问。
