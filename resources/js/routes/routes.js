import MainLayout from '@layouts/MainLayout.vue';

const routes = [
  {
    path: '/',
    name: 'home',
    component: async () => import('@pages/HomePage.vue'),
    meta: {
      requiresAuth: false,
      layout: MainLayout,
    },
  },
];

export default routes;
