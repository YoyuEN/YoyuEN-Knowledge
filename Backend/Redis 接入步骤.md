## Redis 接入步骤

### 第一步：pom.xml 添加依赖

在 `<dependencies>` 中加入：



```xml
<!-- Redis -->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-data-redis</artifactId>
</dependency>
<!-- 连接池（推荐，避免连接泄漏）-->
<dependency>
    <groupId>org.apache.commons</groupId>
    <artifactId>commons-pool2</artifactId>
</dependency>
```

------

### 第二步：application.properties 添加 Redis 配置



```properties
# Redis
spring.data.redis.host=localhost
spring.data.redis.port=6379
# spring.data.redis.password=你的密码（没有设密码就注释掉）
spring.data.redis.database=0
spring.data.redis.timeout=3000ms
# Lettuce 连接池（需要 commons-pool2）
spring.data.redis.lettuce.pool.max-active=8
spring.data.redis.lettuce.pool.max-idle=8
spring.data.redis.lettuce.pool.min-idle=1
spring.data.redis.lettuce.pool.max-wait=1000ms
```

------

### 第三步：新建 RedisConfig 配置类

在 `com.yoyuen.backend.config` 下创建：



```java
@Configuration
public class RedisConfig {

    /**
     * 配置 RedisTemplate，使用 JSON 序列化（代替默认的 JDK 序列化）
     * 这样 Redis 中存的是可读的 JSON，而不是乱码
     */
    @Bean
    public RedisTemplate<String, Object> redisTemplate(RedisConnectionFactory factory) {
        RedisTemplate<String, Object> template = new RedisTemplate<>();
        template.setConnectionFactory(factory);

        Jackson2JsonRedisSerializer<Object> jsonSerializer =
                new Jackson2JsonRedisSerializer<>(Object.class);

        // key 用字符串序列化
        template.setKeySerializer(new StringRedisSerializer());
        template.setHashKeySerializer(new StringRedisSerializer());
        // value 用 JSON 序列化
        template.setValueSerializer(jsonSerializer);
        template.setHashValueSerializer(jsonSerializer);

        template.afterPropertiesSet();
        return template;
    }
}
```

------

### 第四步：针对本系统的缓存策略（重点）

结合你的业务，建议以下几个地方加缓存：

| 接口                           | 缓存 key 示例             | TTL     | 说明                          |
| ------------------------------ | ------------------------- | ------- | ----------------------------- |
| `GET /content/{id}`            | `content:detail:{id}`     | 10 分钟 | 文章详情，修改/删除时主动清除 |
| `GET /content/list/{category}` | `content:list:{category}` | 5 分钟  | 分类列表，新增/删除时清除     |
| `GET /content/recommend`       | `content:recommend`       | 10 分钟 | 推荐列表                      |
| `GET /content/activity`        | `content:activity:{days}` | 1 小时  | 热力图，按天统计变化慢        |
| `GET /comment/recommend`       | `comment:recommend`       | 5 分钟  | 推荐评论                      |
| `GET /photo/list`              | `photo:list`              | 30 分钟 | 相册，变化不频繁              |

------

### 第五步：封装一个 RedisService（可选但推荐）

避免在业务层直接操作 `RedisTemplate`，新建 `com.yoyuen.backend.service.system.RedisService`：