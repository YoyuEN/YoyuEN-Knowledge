import gsap from 'gsap'

/**
 * Content switch transition animation.
 * Fades out current content, runs update callback, then fades in new content.
 */
export async function transitionContent(updateCallback: () => Promise<void> | void) {
  const articleContent = document.querySelector('.article-content')
  const detailCol = document.querySelector('.detail-col')

  // Fade out
  if (articleContent || detailCol) {
    await gsap.to([articleContent, detailCol].filter(Boolean), {
      opacity: 0,
      duration: 0.3,
      ease: 'power2.in',
    })
  }

  // Update data
  await updateCallback()

  // Wait for DOM
  await new Promise((resolve) => setTimeout(resolve, 50))

  // Fade in
  const newArticle = document.querySelector('.article-content')
  const newDetail = document.querySelector('.detail-col')

  if (newArticle || newDetail) {
    gsap.set([newArticle, newDetail].filter(Boolean), { opacity: 0 })
    gsap.to([newArticle, newDetail].filter(Boolean), {
      opacity: 1,
      duration: 0.4,
      ease: 'power2.out',
    })
  }
}
