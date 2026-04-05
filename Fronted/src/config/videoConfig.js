/**
 * 视频加载配置
 * 用于优化视频加载性能和用户体验
 */

export const VIDEO_CONFIG = {
  // 预加载策略
  PRELOAD: {
    CURRENT: 'metadata',  // 当前视频：只加载元数据（快速）
    NEXT: 'metadata',     // 下一个视频：预加载元数据
    OTHER: 'none'         // 其他视频：不预加载
  },

  // 缓冲阈值
  BUFFER: {
    MIN_TO_PLAY: 10,      // 最少缓冲10%才开始播放
    SMOOTH_THRESHOLD: 30  // 缓冲30%以上认为可以流畅播放
  },

  // 加载超时
  TIMEOUT: {
    METADATA: 10000,      // 元数据加载超时：10秒
    INITIAL_BUFFER: 15000 // 初始缓冲超时：15秒
  },

  // 视频质量建议
  QUALITY: {
    MAX_SIZE_MB: 50,      // 建议最大文件大小：50MB
    RECOMMENDED_RESOLUTION: '720p',
    RECOMMENDED_BITRATE: '2M'
  }
}

/**
 * 根据视频索引获取预加载模式
 * @param {number} videoIndex - 视频索引
 * @param {number} currentIndex - 当前播放索引
 * @returns {string} preload 模式
 */
export function getPreloadMode(videoIndex, currentIndex) {
  if (videoIndex === currentIndex) {
    return VIDEO_CONFIG.PRELOAD.CURRENT
  }
  if (videoIndex === currentIndex + 1) {
    return VIDEO_CONFIG.PRELOAD.NEXT
  }
  return VIDEO_CONFIG.PRELOAD.OTHER
}

/**
 * 检查缓冲是否足够播放
 * @param {number} bufferPercent - 缓冲百分比
 * @returns {boolean}
 */
export function isBufferSufficient(bufferPercent) {
  return bufferPercent >= VIDEO_CONFIG.BUFFER.MIN_TO_PLAY
}

/**
 * 检查是否可以流畅播放
 * @param {number} bufferPercent - 缓冲百分比
 * @returns {boolean}
 */
export function canPlaySmoothly(bufferPercent) {
  return bufferPercent >= VIDEO_CONFIG.BUFFER.SMOOTH_THRESHOLD
}
