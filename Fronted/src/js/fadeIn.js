import gsap from 'gsap'

/**
 * 为带有 .fade-in 类的元素添加淡入动画
 * 使用方式：在元素上添加 class="fade-in"
 * 当元素滚动到视口时触发动画
 */
export function initFadeIn() {
  const elements = document.querySelectorAll('.fade-in')

  // 先设置所有元素的初始状态
  elements.forEach((el) => {
    gsap.set(el, {
      opacity: 0,
      y: 20
    })
  })

  // 创建 Intersection Observer
  const observer = new IntersectionObserver(
    (entries) => {
      entries.forEach((entry) => {
        if (entry.isIntersecting) {
          // 元素进入视口时触发动画
          gsap.to(entry.target, {
            opacity: 1,
            y: 0,
            duration: 0.6,
            ease: 'power2.out'
          })
          // 动画完成后停止观察该元素
          observer.unobserve(entry.target)
        }
      })
    },
    {
      threshold: 0.1, // 元素10%可见时触发
      rootMargin: '0px 0px -50px 0px' // 提前50px触发
    }
  )

  // 观察所有元素
  elements.forEach((el) => {
    observer.observe(el)
  })
}

/**
 * 单个元素淡入动画
 * @param {HTMLElement} element - 要添加动画的元素
 * @param {Object} options - 动画配置
 */
export function fadeInElement(element, options = {}) {
  const defaults = {
    duration: 0.6,
    ease: 'power2.out'
  }

  gsap.set(element, {
    opacity: 0,
    y: 20
  })

  gsap.to(element, {
    opacity: 1,
    y: 0,
    ...defaults,
    ...options
  })
}
