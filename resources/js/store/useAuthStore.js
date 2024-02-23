import { defineStore } from 'pinia';
import { LocalStorage } from 'quasar';
import { useResetStore } from '@/utils/useResetStore'

const useAuthStore = defineStore('auth', {
  state: () => ({
    token: null,
    user: null,
    auth: null,
  }),
  persist: {
    key: 'auth',
    storage: localStorage,
  },
  getters: {
    getUser() {
      return JSON.parse(localStorage.getItem('auth')).user;
    },
  },
  actions: {
    setToken(token) {
      this.token = token;
    },
    setUser(user) {
      this.user = user;
    },
    logout() {
      useResetStore.clearAll();
      LocalStorage.clear();
    },
  },
});

export default useAuthStore;
