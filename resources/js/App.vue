<script setup>
</script>

<template>
  <main>
    <component :is="$route.meta.layout || 'div'">
      <RouterView></RouterView>
    </component>
  </main>
</template> 


<style lang="scss">
@import '@css/app.scss';
</style>