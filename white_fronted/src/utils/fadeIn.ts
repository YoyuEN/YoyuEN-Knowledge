import gsap from 'gsap'

/**
 * Initialize fade-in animations for all elements with class `.fade-in`.
 * Elements fade up from 20px offset when they enter the viewport.
 */
export function initFadeIn() {
  const elements = document.querySelectorAll<HTMLElement>('.fade-in')

  // Set initial state
  elements.forEach((el) => {
    gsap.set(el, { opacity: 0, y: 20 })
  })

  const observer = new IntersectionObserver(
    (entries) => {
      entries.forEach((entry) => {
        if (entry.isIntersecting) {
          gsap.to(entry.target, {
            opacity: 1,
            y: 0,
            duration: 0.6,
            ease: 'power2.out',
          })
          observer.unobserve(entry.target)
        }
      })
    },
    {
      threshold: 0.1,
      rootMargin: '0px 0px -50px 0px',
    },
  )

  elements.forEach((el) => observer.observe(el))

  return () => observer.disconnect()
}

interface FadeInElementOptions {
  duration?: number
  ease?: string
  delay?: number
}

/**
 * Trigger a single element fade-in animation.
 */
export function fadeInElement(
  element: HTMLElement | null,
  options: FadeInElementOptions = {},
) {
  if (!element) return

  const { duration = 0.6, ease = 'power2.out', delay = 0 } = options

  gsap.set(element, { opacity: 0, y: 20 })
  gsap.to(element, {
    opacity: 1,
    y: 0,
    duration,
    ease,
    delay,
  })
}
