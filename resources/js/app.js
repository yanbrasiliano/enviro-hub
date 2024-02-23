import { createApp } from 'vue';
import App from '@/App.vue';
import { createPinia } from 'pinia';
import piniaPluginPersistedstate from 'pinia-plugin-persistedstate';
import { Quasar, Notify, Loading, Dialog, Dark, Platform, LocalStorage} from 'quasar';
import '@quasar/extras/material-icons/material-icons.css'
import 'quasar/src/css/index.sass'
import langPTBR from 'quasar/lang/pt-BR';
import router from '@/routes';


Quasar.lang.set(Quasar.lang.ptBR);
const pinia = createPinia();
pinia.use(piniaPluginPersistedstate);
const app = createApp(App);

app.use(pinia);
app.use(router);

app.use(Quasar, {
  lang: langPTBR,
  config: {
    
  },
  plugins: {
    Notify,
    Loading,
    Dialog,
    Dark,
    Platform,
    LocalStorage,
  },
});



app.mount('#app');

