<script setup>
import { ref } from 'vue';

const email = ref('');
const password = ref('');

const login = () => {
  console.log('Dados do login:', { email: email.value, password: password.value });
};
</script>

<template>
  <q-card>
    <q-card-section>
      <q-form @submit.prevent="login">
        <q-input v-model="email" filled label="E-mail" />
        <q-input v-model="password" filled label="Senha" type="password" />
        <div class="q-mt-md">
          <q-btn label="Entrar" type="submit" color="secondary" />
        </div>
      </q-form>
    </q-card-section>
  </q-card>
</template>

<style scoped>
.q-card {
  max-width: none;
  width: 100%;
}

.q-btn {
  width: 100%;
  margin-top: 20px;

}

.q-input {
  margin-bottom: 20px;

}
</style>