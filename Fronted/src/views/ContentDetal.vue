<template>
  <div class="content-container">

    <!-- 左侧：轮播 + 文章内容 -->
    <div class="swiper-col">
      <swiper
        :slides-per-view="1"
        :space-between="16"
        :navigation="true"
        :pagination="{ clickable: true }"
        :initial-slide="initialSlide"
        @swiper="onSwiper"
        @slide-change="onSlideChange"
        class="content-swiper"
      >
        <swiper-slide
          v-for="item in swiperItems"
          :key="item.id"
          class="content-swiper-slide"
        >
          <Card16x9 :background-image="item.cover" class="content-card-item">
            <div class="card-overlay">
              <h4 class="card-name">{{ item.title }}</h4>
              <span class="card-badge">{{ item.category }}</span>
            </div>
          </Card16x9>
        </swiper-slide>
      </swiper>

      <!-- 文章内容区 -->
      <div v-if="currentItem" class="article-content">
        <div class="article-meta">
          <span class="article-tag">{{ currentItem.category }}</span>
          <span class="article-date">{{ currentItem.date }}</span>
        </div>
        <h2 class="article-title">{{ currentItem.title }}</h2>
        <div class="article-ai-summary">
          <div class="ai-label">AI 总结</div>
          <p>{{ currentItem.desc }}</p>
        </div>
        <div class="article-body" v-html="currentItem.content"></div>
      </div>
    </div>

    <!-- 右侧：详情 + 评论 -->
    <div v-if="currentItem" class="detail-col">
      <div class="detail-card">
        <div class="detail-header">
          <h3>{{ currentItem.title }}</h3>
          <span class="detail-badge">{{ currentItem.category }}</span>
        </div>
        <p class="detail-desc">{{ currentItem.desc }}</p>
        <div class="detail-stats">
          <span>📅 {{ currentItem.date }}</span>
          <span>💬 {{ currentItem.comments }} 评论</span>
        </div>
      </div>
      <div class="comment-wrap">
        <CommentSection :data="currentItem" :comments="itemComments" />
      </div>
    </div>

  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { useRoute } from 'vue-router'
import { Swiper, SwiperSlide } from 'swiper/vue'
import 'swiper/css'
import 'swiper/css/navigation'
import 'swiper/css/pagination'
import Card16x9 from '../components/Card16x9.vue'
import CommentSection from '../components/CommentSection.vue'

const route = useRoute()
const type = route.params.type
const itemId = parseInt(route.params.id)

const p = 'https://picsum.photos/seed/'

// ---- 全量数据（与 Content.vue 对应，cover 用大尺寸）----
const allData = {
  article: [
    {
      id: 1, category: '文章', title: 'TypeScript 高级类型体操入门',
      desc: '通过实际案例理解条件类型、映射类型与模板字面量类型，提升代码可维护性。',
      date: '2026-02-22', comments: 45, cover: p + 'ts/800/450',
      content: `
        <h3>什么是类型体操</h3>
        <p>TypeScript 的类型系统是图灵完备的，这意味着我们可以用类型来描述任意复杂的逻辑。"类型体操"泛指那些利用条件类型、映射类型、模板字面量等高级特性编写的复杂类型工具。</p>
        <h3>条件类型</h3>
        <p>条件类型的语法为 <code>T extends U ? X : Y</code>，可以根据类型关系选择不同的输出类型。结合 <code>infer</code> 关键字，可以从泛型中提取部分类型，实现强大的类型推断。</p>
        <h3>映射类型</h3>
        <p>通过 <code>{ [K in keyof T]: ... }</code> 语法可以对对象类型的每个键进行转换，配合 <code>+?</code>、<code>-?</code> 修饰符可以批量添加或移除可选性，Partial、Required、Readonly 都是基于此实现的。</p>
        <h3>模板字面量类型</h3>
        <p>TypeScript 4.1 引入了模板字面量类型，可以将字符串字面量进行拼接和变换，结合 <code>Uppercase</code>、<code>Lowercase</code> 等工具类型，可以实现 camelCase 转 snake_case 等字符串操作。</p>
        <h3>实战建议</h3>
        <p>类型体操的目标是更好地描述业务逻辑，而非炫技。在实际项目中优先选择简单、可读的类型写法；只有在需要封装通用工具库时，才考虑引入复杂的类型推断。</p>
      `
    },
    {
      id: 2, category: '文章', title: 'Docker + Nginx 前端部署最佳实践',
      desc: '一文搞定容器化部署流程，涵盖多阶段构建、反向代理与 HTTPS 配置。',
      date: '2026-02-19', comments: 31, cover: p + 'docker/800/450',
      content: `
        <h3>为什么选择 Docker 部署</h3>
        <p>Docker 将应用与运行环境打包在一起，解决了"在我机器上能跑"的经典问题。对于前端项目，Docker 可以统一构建环境，确保 CI/CD 管线的输出与本地一致。</p>
        <h3>多阶段构建</h3>
        <p>使用多阶段构建可以显著减小镜像体积。第一阶段用 Node 镜像安装依赖并构建产物，第二阶段只将 dist 目录复制到轻量的 Nginx 镜像，最终镜像体积可从数百 MB 压缩到十几 MB。</p>
        <h3>Nginx 反向代理配置</h3>
        <p>前端 SPA 需要配置 <code>try_files $uri $uri/ /index.html</code> 来支持 History 路由模式。同时通过 <code>proxy_pass</code> 指令将 API 请求转发到后端服务，避免跨域问题。</p>
        <h3>HTTPS 与性能优化</h3>
        <p>借助 Let's Encrypt 可以免费申请 SSL 证书，配合 Nginx 开启 HTTP/2 和 gzip 压缩，可以大幅提升传输效率。静态资源建议设置长效缓存并通过文件指纹（hash）实现缓存破坏。</p>
      `
    },
    {
      id: 3, category: '文章', title: '算法每日一题：动态规划系列',
      desc: '整理了 LeetCode 上经典 DP 题型，附详细解题思路与复杂度分析。',
      date: '2026-02-16', comments: 19, cover: p + 'algo/800/450',
      content: `
        <h3>动态规划的本质</h3>
        <p>动态规划的核心是"记住已经解决过的子问题的答案"。相较于暴力递归，DP 通过状态转移方程将重叠子问题的计算从指数级降低到多项式级。</p>
        <h3>线性 DP</h3>
        <p>最经典的线性 DP 包括最长递增子序列（LIS）和最长公共子序列（LCS）。LIS 的 O(n log n) 解法结合了贪心与二分，是面试中最常考的进阶题型之一。</p>
        <h3>区间 DP</h3>
        <p>区间 DP 的状态通常定义为 <code>dp[l][r]</code>，枚举区间内的分割点进行转移。矩阵链乘、戳气球等问题都属于此类，难点在于枚举顺序和边界处理。</p>
        <h3>背包问题</h3>
        <p>01 背包、完全背包、多重背包是 DP 中的经典系列。滚动数组优化可以将空间复杂度从 O(nW) 降到 O(W)，在完全背包中遍历顺序需要从小到大以允许重复选择。</p>
      `
    }
  ],
  game: [
    {
      id: 1, category: '游戏', title: '艾尔登法环 DLC 全 Boss 攻略',
      desc: '影之地全 BOSS 详细打法、武器推荐与伤害机制解析，新手必看。',
      date: '2026-02-21', comments: 87, cover: p + 'elden/800/450',
      content: `
        <h3>影之地概览</h3>
        <p>《黄金树幽影》DLC 新增了一个与本体规模相当的全新地图——影之地。独特的"幽影圣树碎片"系统要求玩家在探索中持续强化影力，直接挑战 BOSS 将面临极高压力。</p>
        <h3>推荐配装思路</h3>
        <p>DLC BOSS 的攻击频率和伤害大幅提升，建议以高韧性、快翻滚为核心。弯刀流或双持直剑在削韧与输出节奏上有明显优势；魔法流派需熟练掌握蓄力时机，避免被打断。</p>
        <h3>关键 BOSS 打法</h3>
        <p>弥可拉女王的攻击存在大量假动作，核心是压制贪刀冲动，等待收招后的 1-2 刀窗口。米凯拉骑士安斯巴赫在第二阶段会召唤圣火流星，需全程保持机动走位。</p>
        <h3>总评</h3>
        <p>《黄金树幽影》在挑战性与内容密度上均超越本体，是魂系游戏史上最高质量的 DLC 之一。建议在主线通关后、充分探索影之地的前提下挑战各 BOSS。</p>
      `
    },
    {
      id: 2, category: '游戏', title: '黑神话：悟空 性能优化设置',
      desc: '高帧率与高画质如何兼得？提供各显卡档次的推荐配置方案。',
      date: '2026-02-17', comments: 53, cover: p + 'wukong/800/450',
      content: `
        <h3>画面设置核心逻辑</h3>
        <p>《黑神话：悟空》使用虚幻引擎 5，Lumen 全局光照和 Nanite 几何体是性能大户。入门显卡（如 RTX 3060）建议关闭 Lumen，改用高质量光栅化模式；旗舰显卡则可全开享受。</p>
        <h3>DLSS / FSR 设置</h3>
        <p>N 卡优先选择 DLSS 质量档，A 卡使用 FSR 2 质量档，可在几乎不损失画质的情况下提升 30-50% 帧率。帧生成（Frame Generation）功能在高基础帧率下效果最佳，延迟感最低。</p>
        <h3>各档次推荐方案</h3>
        <p>RTX 4090：全最高 + DLSS 质量，1440p 可稳定 120fps+；RTX 4070：高预设 + DLSS 质量，1080p 稳定 90fps+；RTX 3060：中预设 + FSR 质量，1080p 稳定 60fps。</p>
        <h3>额外优化技巧</h3>
        <p>关闭 Xbox Game Bar、确保游戏运行在性能模式下、将显卡驱动更新至最新版本，通常可带来额外 5-10% 的性能提升。磁盘 IO 性能对加载速度影响显著，推荐将游戏安装在 NVMe SSD 上。</p>
      `
    },
    {
      id: 3, category: '游戏', title: '星穹铁道 2.3 版本角色强度榜',
      desc: '最新版本各角色 T 档评级，附组队思路与遗器推荐。',
      date: '2026-02-13', comments: 42, cover: p + 'hsr/800/450',
      content: `
        <h3>T0 阵容</h3>
        <p>2.3 版本 T0 阵容以花火队和纯火队为主。花火作为连击辅助，与美游、寒鸦等角色的协同进攻机制高度契合，大幅提升高命值下的爆发上限。</p>
        <h3>T1 核心角色</h3>
        <p>知更鸟（The Herta）凭借超高倍率和群体伤害位列 T1 输出首位。灵砂作为后排精准治疗，可满足大多数高难副本的生存需求，替代了传统奶妈的位置。</p>
        <h3>遗器与光锥推荐</h3>
        <p>主流输出角色推荐"深林游击者"或"随波逐流"套装；辅助角色选择"鹿野院平藏"或"太空封印站"以最大化增益效果。不差钱可考虑匹配专属光锥，收益约提升 15-25%。</p>
        <h3>混服节奏建议</h3>
        <p>跑本路线按"拟宇宙（周常）→ 忘却之庭（双周）→ 虚构叙事（双周）"排序，优先保证积分上限。素材消耗建议以主力队伍满潜为目标，再考虑培养替补。</p>
      `
    }
  ],
  study: [
    {
      id: 1, category: '学习', title: 'Redis 缓存穿透、击穿与雪崩详解',
      desc: '深入理解三大缓存问题的触发场景与对应解决方案，面试高频题。',
      date: '2026-02-23', comments: 28, cover: p + 'redis/800/450',
      content: `
        <h3>缓存穿透</h3>
        <p>缓存穿透指查询一个数据库中不存在的数据，缓存中也没有该数据，导致每次请求都直接打到数据库。攻击者可以利用此特性发起恶意请求使数据库瘫痪。解决方案：①缓存空值（TTL 短）；②布隆过滤器过滤非法 key。</p>
        <h3>缓存击穿</h3>
        <p>缓存击穿指热点 key 在高并发场景下恰好过期，大量请求同时穿透到数据库。解决方案：①互斥锁（只有一个线程重建缓存）；②逻辑过期（不设置 TTL，后台异步更新）。</p>
        <h3>缓存雪崩</h3>
        <p>缓存雪崩指大量 key 在同一时间过期，或 Redis 宕机，导致请求全部打到数据库。解决方案：①为不同 key 的 TTL 加随机偏移；②Redis 集群保证高可用；③熔断降级保护数据库。</p>
        <h3>面试答题模板</h3>
        <p>建议按"定义→触发场景→危害→解决方案→方案对比"的结构回答，重点突出不同方案的适用场景和权衡取舍，例如互斥锁牺牲可用性换一致性，逻辑过期牺牲一致性换可用性。</p>
      `
    },
    {
      id: 2, category: '学习', title: 'MySQL 索引失效的 10 个场景',
      desc: '结合 EXPLAIN 执行计划，逐一分析索引失效原因及优化建议。',
      date: '2026-02-20', comments: 36, cover: p + 'mysql/800/450',
      content: `
        <h3>最左前缀原则</h3>
        <p>联合索引必须从最左列开始使用，跳过中间列会导致索引失效。如索引为 (a, b, c)，查询条件只用 (a, c) 时，c 列的索引无法被利用。</p>
        <h3>列上使用函数或运算</h3>
        <p>对索引列做函数处理（如 YEAR(create_time) = 2026）或四则运算（id + 1 = 10）都会导致索引失效，因为优化器无法直接通过 B+Tree 定位。改写为范围查询可以解决这一问题。</p>
        <h3>隐式类型转换</h3>
        <p>当查询条件的数据类型与列的定义类型不一致时（如 varchar 列用数字查询），MySQL 会进行隐式转换，导致全表扫描。建议严格保持类型一致。</p>
        <h3>使用 OR 连接不同列</h3>
        <p>OR 连接的多个条件，只要其中一个列没有索引，整个查询可能退化为全表扫描。可以将 OR 改写为 UNION ALL，分别利用各列的索引。</p>
        <h3>LIKE 以通配符开头</h3>
        <p><code>LIKE '%abc'</code> 无法利用索引（无法从左侧确定范围），而 <code>LIKE 'abc%'</code> 可以。全文搜索场景建议使用 MySQL 的 FULLTEXT 索引或 Elasticsearch。</p>
      `
    },
    {
      id: 3, category: '学习', title: 'React Hooks 深度解析',
      desc: 'useState、useEffect、useCallback、useMemo 原理与最佳实践。',
      date: '2026-02-14', comments: 22, cover: p + 'react/800/450',
      content: `
        <h3>Hooks 的设计动机</h3>
        <p>Class 组件的生命周期方法常常将不相关的逻辑混合在一起，而 Hooks 允许按功能而非生命周期拆分逻辑，使代码更易于复用和测试。</p>
        <h3>useState 与闭包陷阱</h3>
        <p>useState 的 setter 是稳定引用，但在 useEffect 或事件回调中访问的 state 是闭包捕获的快照值。当需要基于最新 state 更新时，应使用函数式更新：<code>setState(prev => prev + 1)</code>。</p>
        <h3>useEffect 依赖数组</h3>
        <p>依赖数组为空表示只在挂载时执行，省略表示每次渲染都执行。遗漏依赖会导致 effect 使用旧值（stale closure），建议配合 ESLint 的 exhaustive-deps 规则进行检查。</p>
        <h3>useMemo 与 useCallback</h3>
        <p>这两个 Hook 用于缓存计算结果和函数引用，避免子组件因引用变化而不必要地重渲染。但过度使用会增加代码复杂度，建议仅在经 Profiler 确认存在性能问题后使用。</p>
      `
    }
  ],
  video: [
    {
      id: 1, category: '视频', title: '手撕 LRU 缓存算法',
      desc: '用 Map + 双向链表实现 O(1) 操作的 LRU，配合动画演示讲解。',
      date: '2026-02-24', comments: 15, cover: p + 'lru/800/450',
      content: `
        <h3>LRU 简介</h3>
        <p>LRU（Least Recently Used）是一种常见的缓存淘汰策略，当缓存满时驱逐最久未使用的数据。Redis、操作系统页面置换等场景中均有广泛应用。</p>
        <h3>数据结构选型</h3>
        <p>HashMap 可以做到 O(1) 的随机访问，但无法维护顺序；双向链表可以 O(1) 地在任意位置插入和删除，但查找是 O(n)。两者结合即可实现 get 和 put 均为 O(1)。</p>
        <h3>核心操作逻辑</h3>
        <p>get：若 key 存在，将节点移到链表头部（最近使用）并返回值；若不存在返回 -1。put：若 key 存在，更新值并移到头部；若不存在，新建节点插入头部，若容量超限则删除链表尾节点并从 Map 中移除对应 key。</p>
        <h3>Java 中的 LinkedHashMap</h3>
        <p>Java 标准库的 LinkedHashMap 内置了维护插入/访问顺序的能力，通过重写 removeEldestEntry 方法可以一行代码实现 LRU。面试中手撕是为了展示对底层原理的理解，实际生产环境直接使用即可。</p>
      `
    },
    {
      id: 2, category: '视频', title: '我的 2025 年度总结',
      desc: '记录这一年的技术成长、生活感悟与新年计划，欢迎一起交流。',
      date: '2026-02-11', comments: 33, cover: p + 'vlog/800/450',
      content: `
        <h3>技术成长</h3>
        <p>2025 年完成了从纯前端到全栈方向的转型，系统学习了 Spring Boot 微服务、Docker 容器化部署和 Redis 缓存体系。最大的收获是理解了分布式系统的设计思维，不再局限于单一技术栈。</p>
        <h3>项目实践</h3>
        <p>独立完成了知识库系统的全栈开发，从需求分析到上线运维一手包办。踩了很多坑——JWT 鉴权、MinIO 文件存储、RAG 知识检索，每一个都是一次深度学习。</p>
        <h3>生活感悟</h3>
        <p>坚持健身整整一年，体重和状态都有明显改变。最重要的领悟是：计划没有变化快，与其制定完美计划，不如每天做一件微小但确定的事。</p>
        <h3>2026 展望</h3>
        <p>希望在 AI 应用开发方向有更深入的探索，把知识库系统升级为真正可用的产品。同时想尝试技术写作，把学到的东西用更清晰的方式分享出去。</p>
      `
    },
    {
      id: 3, category: '视频', title: 'Gym 健身入门：如何制定训练计划',
      desc: '从零开始的健身指南，动作讲解 + 饮食建议，适合健身新手。',
      date: '2026-02-08', comments: 20, cover: p + 'gym/800/450',
      content: `
        <h3>新手最常见的误区</h3>
        <p>很多新手把大量时间花在器械练习上，却忽略了自由重量和复合动作的重要性。深蹲、硬拉、卧推、引体向上这四个基础动作，足以覆盖全身大肌群，是入门训练的核心。</p>
        <h3>训练频率与分化</h3>
        <p>新手建议从全身训练（每周 3 次）开始，让各肌群有充分的恢复时间。有一定基础后可以过渡到上下肢分化（每周 4 次）或推拉腿分化（每周 5-6 次）。</p>
        <h3>饮食基础</h3>
        <p>增肌期热量盈余 300-500 大卡，蛋白质摄入目标为体重（kg）× 1.6-2.2g。减脂期热量缺口 300-500 大卡，维持蛋白质摄入以减少肌肉流失。不需要精确计算每一克食物，养成大致估算习惯即可。</p>
        <h3>关于坚持</h3>
        <p>健身的最大难关不是动作标准，而是持续出现在健身房。建议将健身融入日常作息，固定时间、固定地点，降低启动成本。第一个月可能进步最快——把握好新手福利期，建立起正向反馈。</p>
      `
    }
  ]
}

// 当前类型的 swiper 数据
const swiperItems = allData[type] || []

// 初始 swiper 位置
const initialSlide = swiperItems.findIndex(i => i.id === itemId)

// 当前选中项
const currentItem = ref(swiperItems.find(i => i.id === itemId) || swiperItems[0] || null)

let swiperInstance = null

const onSwiper = (swiper) => {
  swiperInstance = swiper
}

const onSlideChange = () => {
  if (swiperInstance) {
    currentItem.value = swiperItems[swiperInstance.activeIndex] || null
  }
}

// 每条内容的评论数据
const commentsMap = {
  'article-1': [
    { id: 1, avatar: '/src/assets/picture/YoyuEN.png', author: '前端开发者', time: '2026-02-23 10:00', content: '类型体操的文章很少见写得这么清晰的，收藏了！', replies: [] },
    { id: 2, avatar: '/src/assets/picture/YoyuEN.png', author: '学习中', time: '2026-02-22 16:30', content: '请问 infer 关键字有没有更多实战案例推荐？', replies: [] }
  ],
  'article-2': [
    { id: 1, avatar: '/src/assets/picture/YoyuEN.png', author: '运维工程师', time: '2026-02-20 09:15', content: '多阶段构建这部分讲得很到位，我们团队正好在推进容器化。', replies: [] }
  ],
  'article-3': [
    { id: 1, avatar: '/src/assets/picture/YoyuEN.png', author: '刷题人', time: '2026-02-17 14:00', content: '区间 DP 一直是我的弱项，这篇帮了大忙。', replies: [] },
    { id: 2, avatar: '/src/assets/picture/YoyuEN.png', author: '算法爱好者', time: '2026-02-16 20:30', content: '背包问题的滚动数组优化可以再出一篇详细讲讲吗？', replies: [] }
  ],
  'game-1': [
    { id: 1, avatar: '/src/assets/picture/YoyuEN.png', author: '魂游老手', time: '2026-02-22 11:00', content: '弥可拉的假动作真的坑了我好多次，这个攻略来得及时。', replies: [] },
    { id: 2, avatar: '/src/assets/picture/YoyuEN.png', author: '新人', time: '2026-02-21 18:00', content: '我打了三十几次还没过，感谢攻略！', replies: [] }
  ],
  'game-2': [
    { id: 1, avatar: '/src/assets/picture/YoyuEN.png', author: '硬件党', time: '2026-02-18 13:00', content: '3060 用你的方案设置之后帧率稳了很多，谢谢！', replies: [] }
  ],
  'game-3': [
    { id: 1, avatar: '/src/assets/picture/YoyuEN.png', author: '铁道迷', time: '2026-02-14 10:30', content: '知更鸟真的强，期待下一版本的强度榜！', replies: [] }
  ],
  'study-1': [
    { id: 1, avatar: '/src/assets/picture/YoyuEN.png', author: '备战面试', time: '2026-02-24 08:00', content: '面试必问题，讲得很全面，背下来了！', replies: [] }
  ],
  'study-2': [
    { id: 1, avatar: '/src/assets/picture/YoyuEN.png', author: 'DBA', time: '2026-02-21 15:00', content: '第三条隐式转换这个坑踩过，很有共鸣。', replies: [] }
  ],
  'study-3': [
    { id: 1, avatar: '/src/assets/picture/YoyuEN.png', author: 'React 新手', time: '2026-02-15 20:00', content: '闭包陷阱这块终于搞明白了，之前一直踩坑。', replies: [] }
  ],
  'video-1': [
    { id: 1, avatar: '/src/assets/picture/YoyuEN.png', author: '手撕代码', time: '2026-02-25 09:00', content: '动画演示特别直观，Map + 双链表的组合彻底想通了。', replies: [] }
  ],
  'video-2': [
    { id: 1, avatar: '/src/assets/picture/YoyuEN.png', author: '同龄人', time: '2026-02-12 21:00', content: '感同身受！2026 一起加油！', replies: [] },
    { id: 2, avatar: '/src/assets/picture/YoyuEN.png', author: '读者', time: '2026-02-11 19:00', content: 'RAG 知识库这块能单独出一篇文章吗？', replies: [] }
  ],
  'video-3': [
    { id: 1, avatar: '/src/assets/picture/YoyuEN.png', author: '健身新手', time: '2026-02-09 07:30', content: '新手误区那段说到心坎里了，我就是只用器械的那种。', replies: [] }
  ]
}

const itemComments = computed(() => {
  if (!currentItem.value) return []
  return commentsMap[`${type}-${currentItem.value.id}`] || []
})
</script>

<style scoped>
@font-face {
  font-family: '快看世界体';
  src: url('../assets/fonts/kuaikanshijieti.ttf') format('truetype');
}

.content-container {
  margin-top: 70px;
  margin-bottom: 20px;
  padding: 0 24px;
  height: calc(100vh - 90px);
  display: flex;
  gap: 24px;
  overflow: hidden;
}

/* ---- 左侧 ---- */
.swiper-col {
  width: 55%;
  height: 100%;
  overflow-y: auto;
  scrollbar-width: none;
}

.swiper-col::-webkit-scrollbar {
  display: none;
}

.content-swiper {
  width: 100%;
  height: 420px;
  margin-top: 20px;
  flex-shrink: 0;
}

.content-swiper-slide {
  width: 100%;
  height: 100%;
  display: flex;
  justify-content: center;
  align-items: center;
}

.content-card-item {
  width: 100%;
  height: 70%;
  cursor: pointer;
}

.card-overlay {
  width: 100%;
  height: 100%;
  display: flex;
  flex-direction: column;
  justify-content: flex-end;
  padding: 16px;
  background: linear-gradient(to top, rgba(0,0,0,0.7) 0%, transparent 60%);
}

.card-name {
  margin: 0 0 8px;
  font-size: 16px;
  font-weight: 600;
  color: #fff;
  text-shadow: 0 2px 4px rgba(0,0,0,0.3);
  font-family: '快看世界体', system-ui, sans-serif;
}

.card-badge {
  font-size: 12px;
  color: rgba(255,255,255,0.9);
  background: rgba(255,255,255,0.2);
  backdrop-filter: blur(4px);
  padding: 3px 10px;
  border-radius: 4px;
  width: fit-content;
}

/* 文章内容区 */
.article-content {
  margin-top: 24px;
  background: #fff;
  border-radius: 12px;
  border: 1px solid #ebebeb;
  padding: 28px 32px 32px;
}

.article-meta {
  display: flex;
  align-items: center;
  gap: 10px;
  margin-bottom: 12px;
}

.article-tag {
  font-size: 11px;
  color: #666;
  background: #f2f2f2;
  padding: 2px 10px;
  border-radius: 20px;
}

.article-date {
  font-size: 12px;
  color: #bbb;
}

.article-title {
  font-size: 20px;
  font-weight: 700;
  color: #1a1a1a;
  margin: 0 0 20px;
  line-height: 1.4;
}

.article-ai-summary {
  background: #f8f8f8;
  border-radius: 8px;
  padding: 16px 20px;
  margin-bottom: 24px;
}

.ai-label {
  font-size: 12px;
  font-weight: 600;
  color: #888;
  margin-bottom: 8px;
  letter-spacing: 0.5px;
}

.article-ai-summary p {
  margin: 0;
  font-size: 13px;
  color: #666;
  line-height: 1.8;
}

.article-body {
  font-size: 14px;
  color: #333;
  line-height: 1.9;
}

.article-body :deep(h3) {
  font-size: 16px;
  font-weight: 600;
  color: #1a1a1a;
  margin: 24px 0 10px;
  padding-left: 10px;
  border-left: 3px solid #d0d0d0;
}

.article-body :deep(p) {
  margin: 0 0 14px;
  color: #555;
}

.article-body :deep(code) {
  background: #f2f2f2;
  padding: 1px 5px;
  border-radius: 3px;
  font-size: 13px;
  font-family: 'Consolas', monospace;
}

/* ---- 右侧 ---- */
.detail-col {
  width: 45%;
  height: 100%;
  overflow-y: auto;
  padding-top: 20px;
  scrollbar-width: none;
}

.detail-col::-webkit-scrollbar {
  display: none;
}

.detail-card {
  background: #fff;
  border: 1px solid #ebebeb;
  border-radius: 10px;
  padding: 20px;
  margin-bottom: 20px;
}

.detail-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  gap: 12px;
  margin-bottom: 12px;
}

.detail-header h3 {
  margin: 0;
  font-size: 18px;
  font-weight: 700;
  color: #1a1a1a;
  line-height: 1.4;
  font-family: '快看世界体', system-ui, sans-serif;
}

.detail-badge {
  flex-shrink: 0;
  font-size: 11px;
  color: #666;
  background: #f2f2f2;
  padding: 3px 10px;
  border-radius: 20px;
}

.detail-desc {
  font-size: 13px;
  color: #666;
  line-height: 1.8;
  margin: 0 0 14px;
}

.detail-stats {
  display: flex;
  gap: 16px;
  font-size: 12px;
  color: #bbb;
}

.comment-wrap {
  background: #fff;
  border: 1px solid #ebebeb;
  border-radius: 10px;
  overflow: hidden;
}
</style>
