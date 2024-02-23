import { createRouter, createWebHistory } from 'vue-router';
import routes from './routes';
import useAuthStore from '@/store/useAuthStore';
// import { getUserPermissionsService } from '@/services/roleService';

const router = createRouter({
  history: createWebHistory(),
  routes,
});

const isAuthenticated = (user) => {
  return user.token !== null;
};

// eslint-disable-next-line no-unused-vars
router.beforeEach((to, from, next) => {
  const user = useAuthStore();
  if (to.matched.some((record) => record.meta.requiresAuth)) {
    if (!isAuthenticated(user)) {
      next('/');
    } else {
      // getUserPermissionsService();
      next();
    }
  } else {
    next();
  }
});

export default router;
