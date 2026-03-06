import gsap from 'gsap'

/**
 * 内容切换过渡动画
 * @param {Function} updateCallback - 数据更新回调函数
 */
export async function transitionContent(updateCallback) {
  // 先淡出当前内容
  const articleContent = document.querySelector('.article-content')
  const detailCol = document.querySelector('.detail-col')

  if (articleContent || detailCol) {
    await gsap.to([articleContent, detailCol].filter(Boolean), {
      opacity: 0,
      duration: 0.3,
      ease: 'power2.in'
    })
  }

  // 执行数据更新
  await updateCallback()

  // 等待 DOM 更新后淡入新内容
  await new Promise(resolve => setTimeout(resolve, 50))

  const newArticleContent = document.querySelector('.article-content')
  const newDetailCol = document.querySelector('.detail-col')

  if (newArticleContent || newDetailCol) {
    gsap.set([newArticleContent, newDetailCol].filter(Boolean), {
      opacity: 0
    })
    gsap.to([newArticleContent, newDetailCol].filter(Boolean), {
      opacity: 1,
      duration: 0.4,
      ease: 'power2.out'
    })
  }
}
