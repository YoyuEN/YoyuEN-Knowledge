<template>
  <Layout />
</template>

<script setup>
import Layout from './components/Layout.vue'
import { useTheme } from './composables/useTheme'

const { initTheme } = useTheme()
initTheme()
</script>
