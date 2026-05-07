import fs from 'fs';
import path from 'path';

const html = fs.readFileSync('index.html', 'utf8');

// Ensure directories exist
['src/views', 'src/components', 'src/router'].forEach(dir => {
    fs.mkdirSync(dir, { recursive: true });
});

// Extract CSS
const cssMatch = html.match(/<style>([\s\S]*?)<\/style>/);
if (cssMatch) {
    fs.writeFileSync('src/style.css', "@import 'tailwindcss';\n" + cssMatch[1].trim());
}

// Extract Sidebar
const sidebarMatch = html.match(/<!-- SIDEBAR -->([\s\S]*?)<!-- MAIN CONTENT -->/);
if (sidebarMatch) {
    let sidebarContent = sidebarMatch[1].trim();
    sidebarContent = sidebarContent.replace(/onclick="switchView\('dashboard'\)"/g, '@click="$router.push(\'/\')"');
    sidebarContent = sidebarContent.replace(/onclick="switchView\('solicitudes'\)"/g, '@click="$router.push(\'/solicitudes\')"');
    sidebarContent = sidebarContent.replace(/onclick="switchView\('usuarios'\)"/g, '@click="$router.push(\'/usuarios\')"');
    sidebarContent = sidebarContent.replace(/onclick="switchView\('configuraciones'\)"/g, '@click="$router.push(\'/configuraciones\')"');
    
    fs.writeFileSync('src/components/Sidebar.vue', `<template>\n${sidebarContent}\n</template>\n<script setup></script>`);
}

// Views extraction
const views = [
    { name: 'dashboard', regex: /<!-- VIEW: DASHBOARD -->([\s\S]*?)<!-- VIEW: GESTIÓN DE SOLICITUDES -->/ },
    { name: 'solicitudes', regex: /<!-- VIEW: GESTIÓN DE SOLICITUDES -->([\s\S]*?)<!-- VIEW: USUARIOS -->/ },
    { name: 'usuarios', regex: /<!-- VIEW: USUARIOS -->([\s\S]*?)<!-- VIEW: CONFIGURACIONES -->/ },
    { name: 'configuraciones', regex: /<!-- VIEW: CONFIGURACIONES -->([\s\S]*?)<\/div>\s*<\/div>\s*<\/div>\s*<\/div>\s*<!-- MODAL FOR NEW SOLICITUD -->/ }
];

views.forEach(view => {
    const match = html.match(view.regex);
    if (match) {
        let content = match[1].trim();
        // Remove class="view-section active" and class="view-section" since Vue router handles this
        content = content.replace('class="view-section active"', '');
        content = content.replace('class="view-section"', '');
        const filename = view.name.charAt(0).toUpperCase() + view.name.slice(1) + 'View.vue';
        fs.writeFileSync(`src/views/${filename}`, `<template>\n<div>\n${content}\n</div>\n</template>\n<script setup></script>`);
    }
});

// Extract Modal
const modalMatch = html.match(/<!-- MODAL FOR NEW SOLICITUD -->([\s\S]*?)<script>/);
if (modalMatch) {
    const modalContent = modalMatch[1].trim();
    fs.writeFileSync('src/components/SolicitudModal.vue', `<template>\n${modalContent}\n</template>\n<script setup></script>`);
}

// Create Router
const routerCode = `import { createRouter, createWebHistory } from 'vue-router'
import DashboardView from '../views/DashboardView.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    { path: '/', name: 'dashboard', component: DashboardView },
    { path: '/solicitudes', name: 'solicitudes', component: () => import('../views/SolicitudesView.vue') },
    { path: '/usuarios', name: 'usuarios', component: () => import('../views/UsuariosView.vue') },
    { path: '/configuraciones', name: 'configuraciones', component: () => import('../views/ConfiguracionesView.vue') }
  ]
})
export default router
`;
fs.writeFileSync('src/router/index.js', routerCode);

// Create App.vue
const appCode = `<template>
  <div class="flex h-screen bg-gray-50">
    <Sidebar />
    <div class="flex-1 flex flex-col overflow-hidden">
        <div class="bg-white border-b border-gray-200 px-8 py-6 shadow-sm">
            <div class="breadcrumb">
                Sistema de Gestión de Podas >
                <span id="breadcrumb-section">{{ routeName }}</span>
            </div>
            <h1 class="page-title">{{ routeTitle }}</h1>
            <p class="page-subtitle">{{ routeSubtitle }}</p>
        </div>
        <div class="flex-1 overflow-y-auto">
            <div class="main-content p-8">
                <router-view></router-view>
            </div>
        </div>
    </div>
    <SolicitudModal v-if="showModal" @close="showModal = false" />
  </div>
</template>

<script setup>
import { computed, ref } from 'vue'
import { useRoute } from 'vue-router'
import Sidebar from './components/Sidebar.vue'
import SolicitudModal from './components/SolicitudModal.vue'

const route = useRoute()
const showModal = ref(false)

const routeName = computed(() => {
    const map = {
        dashboard: "Dashboard",
        solicitudes: "Gestión de Solicitudes",
        usuarios: "Usuarios",
        configuraciones: "Configuraciones",
    }
    return map[route.name] || 'Dashboard'
})

const routeTitle = computed(() => {
    const map = {
        dashboard: "Panel de Control",
        solicitudes: "Gestión de Solicitudes",
        usuarios: "Gestión de Usuarios",
        configuraciones: "Configuraciones del Sistema",
    }
    return map[route.name] || 'Panel de Control'
})

const routeSubtitle = computed(() => {
    const map = {
        dashboard: "Visualiza el estado general del sistema y tus solicitudes activas",
        solicitudes: "Administra todas las solicitudes de podas y derribles del sistema",
        usuarios: "Administra los usuarios del sistema y sus permisos de acceso",
        configuraciones: "Ajusta los parámetros y configuraciones generales del sistema",
    }
    return map[route.name] || ''
})
</script>
`;
fs.writeFileSync('src/App.vue', appCode);

// Create main.js
const mainCode = `import { createApp } from 'vue'
import './style.css'
import App from './App.vue'
import router from './router'

const app = createApp(App)
app.use(router)
app.mount('#app')
`;
fs.writeFileSync('src/main.js', mainCode);

// Create new index.html
const indexCode = `<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Sistema de Gestión de Podas v1.0</title>
    <!-- Tailwind CSS via CDN -->
    <script src="https://cdn.tailwindcss.com"></script>
    <!-- Chart.js via CDN -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/3.9.1/chart.min.js"></script>
</head>
<body>
    <div id="app"></div>
    <script type="module" src="/src/main.js"></script>
</body>
</html>
`;
fs.writeFileSync('index.html', indexCode);

console.log("Refactor completed successfully!");
