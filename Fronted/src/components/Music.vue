<template>
  <div class="music-container">
    <div class="music-table-wrapper">
      <el-table :data="songList" style="width: 100%" stripe class="music-table">
        <el-table-column width="50" align="center">
          <template #default="{ $index }">
            <span class="song-index">{{ $index + 1 }}</span>
          </template>
        </el-table-column>
        <el-table-column label="封面" width="70">
          <template #default="{ row }">
            <div class="song-cover">
              <el-image :src="row.cover" fit="cover" class="cover-image">
                <template #error>
                  <div class="cover-placeholder">
                    <el-icon><Headset /></el-icon>
                  </div>
                </template>
              </el-image>
            </div>
          </template>
        </el-table-column>
        <el-table-column prop="name" label="歌曲">
          <template #default="{ row }">
            <div class="song-name">
              <span>{{ row.name }}</span>
            </div>
          </template>
        </el-table-column>
        <el-table-column prop="artist" label="歌手" width="120" />
        <el-table-column prop="album" label="专辑" width="140" />
        <el-table-column prop="duration" label="时长" width="80" align="center">
          <template #default="{ row }">
            <span class="song-duration">{{ row.duration }}</span>
          </template>
        </el-table-column>
      </el-table>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { Headset } from '@element-plus/icons-vue'
import defaultCover from '../assets/picture/YoyuEN.png'

const songList = ref([
  { name: '稻香', artist: '周杰伦', album: '魔杰座', duration: '3:45', cover: defaultCover },
  { name: '青花瓷', artist: '周杰伦', album: '依然范特西', duration: '4:20', cover: defaultCover },
  { name: '听妈妈的话', artist: '周杰伦', album: '依然范特西', duration: '3:15', cover: defaultCover },
  { name: '晴天', artist: '周杰伦', album: '叶惠美', duration: '4:28', cover: defaultCover },
  { name: '七里香', artist: '周杰伦', album: '七里香', duration: '4:55', cover: defaultCover },
  { name: '告白气球', artist: '周杰伦', album: '周杰伦的床边故事', duration: '3:35', cover: defaultCover },
  { name: '等你下课', artist: '周杰伦', album: '等你下课', duration: '4:32', cover: defaultCover },
  { name: '简单爱', artist: '周杰伦', album: '范特西', duration: '4:33', cover: defaultCover }
])
</script>

<style scoped>
.music-container {
  padding: 24px;
  height: 100%;
  overflow-y: auto;
}

.music-header {
  display: flex;
  align-items: center;
  gap: 16px;
  margin-bottom: 24px;
  padding-bottom: 16px;
  border-bottom: 1px solid var(--border-color);
}

.header-icon {
  width: 48px;
  height: 48px;
  border-radius: 12px;
  background: linear-gradient(135deg, var(--primary-color), var(--primary-color-light));
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
}

.header-content h3 {
  margin: 0 0 4px;
  font-size: 20px;
  font-weight: 600;
  color: var(--text-primary);
}

.song-count {
  font-size: 13px;
  color: var(--text-secondary);
}

.music-table-wrapper {
  background: var(--hover-bg);
  border-radius: 12px;
  padding: 16px;
}

.song-cover {
  width: 48px;
  height: 48px;
  border-radius: 8px;
  overflow: hidden;
}

.cover-image {
  width: 100%;
  height: 100%;
}

.cover-placeholder {
  width: 100%;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, var(--primary-color), var(--primary-color-light));
  color: white;
  border-radius: 8px;
}

.song-index {
  color: var(--text-secondary);
  font-size: 13px;
}

.song-name {
  color: var(--text-primary);
  font-weight: 500;
}

.song-duration {
  color: var(--text-secondary);
  font-size: 13px;
}

:deep(.music-table) {
  --el-table-bg-color: transparent;
  --el-table-tr-bg-color: transparent;
  --el-table-header-bg-color: transparent;
  --el-table-row-hover-bg-color: var(--menu-hover-bg);
  --el-table-border-color: transparent;
}

:deep(.music-table th) {
  background-color: transparent;
  color: var(--text-secondary);
  font-size: 12px;
  font-weight: 500;
  border-bottom: none;
}

:deep(.music-table td) {
  border-bottom: 1px solid var(--border-color);
}

:deep(.music-table .el-table__row:hover) {
  background-color: var(--menu-hover-bg);
}

.music-container::-webkit-scrollbar {
  width: 6px;
}

.music-container::-webkit-scrollbar-track {
  background: transparent;
}

.music-container::-webkit-scrollbar-thumb {
  background: var(--primary-color);
  border-radius: 3px;
}
</style>
