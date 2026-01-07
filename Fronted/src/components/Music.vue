<template>
  <div class="music-container">
    <Card16x9 :background-image="defaultCover">
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
    </Card16x9>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { Headset } from '@element-plus/icons-vue'
import Card16x9 from './Card16x9.vue'
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

.music-table-wrapper {
  width: 100%;
  height: 100%;
  padding: 24px;
  display: flex;
  flex-direction: column;
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
  color: white;
  font-size: 13px;
}

.song-name {
  color: white;
  font-weight: 500;
}

.song-duration {
  color: rgba(255, 255, 255, 0.8);
  font-size: 13px;
}

:deep(.music-table) {
  --el-table-bg-color: transparent;
  --el-table-tr-bg-color: transparent;
  --el-table-header-bg-color: transparent;
  --el-table-row-hover-bg-color: rgba(255, 255, 255, 0.1);
  --el-table-border-color: transparent;
}

:deep(.music-table th) {
  background-color: transparent;
  color: rgba(255, 255, 255, 0.8);
  font-size: 12px;
  font-weight: 500;
  border-bottom: none;
}

:deep(.music-table td) {
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
  color: white;
}

:deep(.music-table .el-table__row:hover) {
  background-color: rgba(255, 255, 255, 0.1);
}

:deep(.el-table__body-wrapper) {
  overflow-y: auto;
  max-height: calc(100% - 40px);
}

:deep(.el-table__body-wrapper::-webkit-scrollbar) {
  width: 6px;
}

:deep(.el-table__body-wrapper::-webkit-scrollbar-track) {
  background: transparent;
}

:deep(.el-table__body-wrapper::-webkit-scrollbar-thumb) {
  background: rgba(255, 255, 255, 0.3);
  border-radius: 3px;
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
