<template>
  <section>
    <div class="page-header">
      <div>
        <h1 class="page-title">数据统计</h1>
        <p class="page-desc">观察内容生产、审核效率与访问趋势。</p>
      </div>
      <el-button>导出报表</el-button>
    </div>

    <div class="metric-grid">
      <article class="metric-card" v-for="item in metrics" :key="item.label">
        <p class="metric-label">{{ item.label }}</p>
        <p class="metric-value">{{ item.value }}</p>
        <p class="metric-extra">{{ item.extra }}</p>
      </article>
    </div>

    <el-card class="section-card">
      <template #header>发布漏斗</template>
      <el-row :gutter="16">
        <el-col :span="8" v-for="item in funnel" :key="item.label">
          <p class="metric-label">{{ item.label }}</p>
          <el-progress :percentage="item.percent" :stroke-width="10" />
        </el-col>
      </el-row>
    </el-card>
  </section>
</template>

<script setup>
const metrics = [
  { label: '近 7 天发布量', value: '84', extra: '较上周 +13%' },
  { label: '平均审核时长', value: '2.6h', extra: '较上周 -0.5h' },
  { label: '阅读转化率', value: '27.4%', extra: '较上周 +2.1%' },
  { label: '活跃贡献者', value: '39', extra: '较上周 +4' },
]

const funnel = [
  { label: '草稿创建', percent: 100 },
  { label: '提交审核', percent: 72 },
  { label: '审核通过', percent: 63 },
]
</script>
