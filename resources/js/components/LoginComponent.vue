<script setup>
import baseLayout from '@/assets/background.png'
</script>
<template>
  <div class="row">
    <section class="gt-xs col-sm-6 left-side-content-wrapper">
      <div class="layout-background">
        <q-img :src="baseLayout" alt="Layout Background" class="background-image" />
      </div>
    </section>
    <section class="col-xs-12 col-sm-6 q-pa-xl row justify-center items-center right-side-content-wrapper">
      <div class="right-side-content">
        <q-img style="max-width: 223px; height: 72px" :src="logo" fit="contain">
        </q-img>


        <div class="text-headline1 q-mt-xl q-mb-md gt-xs">Acesse a plataforma</div>

        <p class="">Faça login ou registre-se para começar</p>

        <div class="q-mt-xl q-mb-lg">
          <slot></slot>
        </div>

        <div class="text-title2">
        </div>

        <q-img style="width: 124px; height: auto" class="q-mt-xl" :src="logo" fit="contain">
        </q-img>
      </div>
    </section>
  </div>
</template>

<style scoped>
.bg-image {
  background-repeat: no-repeat;
  background-size: 100% 100%;
}

.image-text {
  color: white;
  width: 80%;
}

.right-side-content {
  width: 80%;
  max-width: 385px;
}

.right-side-content-wrapper {
  min-height: 100vh;
}

.left-side-content-wrapper {
  min-height: 100vh;
}
</style>
