import request from '@/utils/request'

/** 获取照片列表 */
export function fetchPhotoList() {
  return request.get('/photo/list')
}

/**
 * 上传照片
 * @param formData 包含 file 和可选的 description
 */
export function uploadPhoto(formData: FormData) {
  return request.post('/photo/upload', formData, {
    headers: { 'Content-Type': 'multipart/form-data' },
  })
}

/** 删除照片 */
export function removePhoto(id: string) {
  return request.post('/photo/remove', null, { params: { id } })
}

/** 更新照片信息 */
export function updatePhoto(data: { id: string; description: string }) {
  return request.post('/photo/update', data)
}
