import request from '@/utils/request'

/**
 * 获取照片列表
 */
export function fetchPhotoList() {
  return request.get('/photo/list')
}

/**
 * 上传照片
 * @param {FormData} formData 包含 file 和可选的 description
 */
export function uploadPhoto(formData) {
  return request.post('/photo/upload', formData, {
    headers: { 'Content-Type': 'multipart/form-data' }
  })
}

/**
 * 删除照片
 * @param {string} id
 */
export function removePhoto(id) {
  return request.post('/photo/remove', null, { params: { id } })
}
