import axios from 'axios';
import { Loading, Notify } from 'quasar';
import useAuthStore from '@/store/useAuthStore';
import router from '@/routes';

const IS_DEBUG = import.meta.env.VITE_APP_DEBUG === 'true';

const http = axios.create({
  baseURL: import.meta.env.VITE_API_URL,
  timeout: 30000,
  withCredentials: true,
  headers: {
    'X-Requested-With': 'XMLHttpRequest',
    'Content-Type': 'application/json',
  },
});

http.interceptors.request.use((request) => {
  const authStore = useAuthStore();
  if (authStore.token) {
    request.headers.Authorization = `Bearer ${authStore.token}`;
  }
  return request;
});

http.interceptors.response.use(
  (response) => response,
  (error) => {
    Loading.hide();

    if (!error.response) {
      Notify.create({
        position: 'top-right',
        color: 'negative',
        message: 'Ocorreu um erro de rede inesperado.',
      });
      return Promise.reject(error);
    }

    const timeoutMessage = 'Não foi possível carregar esta página corretamente, verifique sua conexão com a internet e tente novamente';
    if (error.code === 'ECONNABORTED') {
      notifyError(timeoutMessage);
      return Promise.reject({ message: timeoutMessage });
    }

    const { status, data } = error.response;
    const authStore = useAuthStore();
    const message = data?.message || 'Erro inesperado';

    handleErrorResponse(status, message, authStore);
    if (IS_DEBUG) {
      return Promise.reject(error);
    }
    return Promise.reject(error.response.data);
  },
);

function notifyError(message) {
  Notify.create({
    position: 'top-right',
    color: 'negative',
    message: message,
  });
}

function handleErrorResponse(status, message, authStore) {
  switch (status) {
    case 404:
      notifyError(message);
      break;
    case 401:
      notifyError(message);
      authStore.logout();
      window.location.href = '/';
      break;
    case 403:
      notifyError(message);
      router.go(-1);
      break;
    case 408:
      notifyError('Tempo de solicitação esgotado');
      break;
    case 422:
    case 429:
      notifyError(message);
      break;
    default:
      if (message === 'This action is unauthorized.') {
        message = 'Esta ação não é autorizada.';
        setTimeout(() => {
          window.location.href = '/admin/inicio';
        }, 500);
      }
      notifyError(message);
      break;
  }
}

export default http;
